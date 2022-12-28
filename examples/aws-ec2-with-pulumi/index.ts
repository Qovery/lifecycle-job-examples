import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as fs from "fs";

function generateCidr(key: string): string {
  // Convert the key string to a number between 0 and 65535
  const hash = key.split('').reduce((acc, cur) => acc + cur.charCodeAt(0), 0) % 65536;
  // Use the key string to generate the second and third bytes of the block
  const byte2 = hash % 256;
  // Return the CIDR in the form "10.0.X.0/24" where X are the hashed bytes
    return `10.0.${byte2}.0/24`;
}

// Get some configuration values or set default values.
const config = new pulumi.Config();
const instanceType = config.get("instanceType") || "t3.micro";
const vpcNetworkCidr = config.get("vpcNetworkCidr") || "10.0.0.0/16";
const qoveryEnvironmentId = process.env.QOVERY_ENVIRONMENT_ID || "5717b78a-86f1-4533-8fc8-71b6de164aee";
// Generate a valid subnet by hashing the environment ID.
// This is done to ensure that the subnet is unique across all environments.
const subnetCidr = generateCidr(qoveryEnvironmentId);

// Look up the latest Amazon Linux 2 AMI.
const ami = aws.ec2.getAmi({
  filters: [{
    name: "name",
    values: ["amzn2-ami-hvm-*"],
  }],
  owners: ["amazon"],
  mostRecent: true,
}).then(invoke => invoke.id);

// User data to start a HTTP server in the EC2 instance
const userData = `#!/bin/bash
echo "Hello, World from Pulumi!" > index.html
nohup python -m SimpleHTTPServer 80 &
`;

// Create VPC.
const vpc = new aws.ec2.Vpc("vpc", {
  cidrBlock: vpcNetworkCidr,
  enableDnsHostnames: true,
  enableDnsSupport: true,
  tags: {
    ttl: "0",
  }
});

// Create an internet gateway.
const gateway = new aws.ec2.InternetGateway("gateway", {
  vpcId: vpc.id,
  tags: {
    ttl: "0",
  }
});

// Create a subnet that automatically assigns new instances a public IP address.
const subnet = new aws.ec2.Subnet("subnet", {
  vpcId: vpc.id,
  cidrBlock: subnetCidr,
  mapPublicIpOnLaunch: true,
  tags: {
    ttl: "0",
  }
});

// Create a route table.
const routeTable = new aws.ec2.RouteTable("routeTable", {
  vpcId: vpc.id,
  routes: [{
    cidrBlock: "0.0.0.0/0",
    gatewayId: gateway.id,
  }],
  tags: {
    ttl: "0",
  }
});

// Associate the route table with the public subnet.
const routeTableAssociation = new aws.ec2.RouteTableAssociation("routeTableAssociation", {
  subnetId: subnet.id,
  routeTableId: routeTable.id,
});

// Create a security group allowing inbound access over port 80 and outbound
// access to anywhere.
const secGroup = new aws.ec2.SecurityGroup("secGroup", {
  description: "Enable HTTP access",
  vpcId: vpc.id,
  ingress: [{
    fromPort: 80,
    toPort: 80,
    protocol: "tcp",
    cidrBlocks: ["0.0.0.0/0"],
  }],
  egress: [{
    fromPort: 0,
    toPort: 0,
    protocol: "-1",
    cidrBlocks: ["0.0.0.0/0"],
  }],
});

// Create and launch an EC2 instance into the public subnet.
const server = new aws.ec2.Instance("server", {
  instanceType: instanceType,
  subnetId: subnet.id,
  vpcSecurityGroupIds: [secGroup.id],
  userData: userData,
  ami: ami,
  tags: {
    Name: "webserver",
    ttl: "0",
  },
});

// Data to export to Qovery
const qoveryOutputFileContent = {
  "EC2_HOSTNAME": {
    "value": server.publicDns,
    "type": "string",
    "sensitive": false,
  },
  "EC2_INSTANCE_TYPE": {
    "value": instanceType,
    "type": "string",
    "sensitive": false,
  },
  "EC2_PUBLIC_IP": {
    "value": server.publicIp,
    "type": "string",
    "sensitive": false,
  },
  "EC2_HOSTNAME_WITH_SCHEME": {
    "value": `http://${server.publicDns}`,
    "type": "string",
    "sensitive": false,
  },
};

// Write the data to a file that will be used by Qovery
fs.writeFile('/qovery-output/qovery-output.json', JSON.stringify(qoveryOutputFileContent, null, 2), function (err) {
  if (err) {
    pulumi.log.warn(err.toString());
  } else {
    pulumi.log.info('/qovery-output/qovery-output.json Saved!');
  }
});

// Export the instance's publicly accessible IP address and hostname.
export const ip = server.publicIp;
export const hostname = server.publicDns;
export const url = pulumi.interpolate`http://${server.publicDns}`;
export const mSubnetCidr = subnetCidr;

