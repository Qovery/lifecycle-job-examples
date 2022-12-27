# Deploy an AWS EC2 instance with Pulumi and Qovery

This example shows how to deploy an AWS EC2 instance with Pulumi and Qovery Lifecycle Job.

## How to use

First, you need to set the following environment variables:
- `PULUMI_ACCESS_TOKEN`: your Pulumi access token
- `AWS_ACCESS_KEY_ID`: your AWS access key ID
- `AWS_SECRET_ACCESS_KEY`: your AWS secret access key
- `AWS_REGION`: your AWS region where you want to deploy your application
- `QOVERY_ENVIRONMENT_ID`: your Qovery environment ID
  - **Local**: You can put a random alphanumeric value for local testing
  - **Qovery**: This environment variable is set automatically by Qovery


To test locally this Serverless Framework example, run the following commands:

```shell
docker build -t aws-ec2-with-pulumi .
```

To deploy our EC2 instance:

```shell
docker run \
  -e PULUMI_ACCESS_TOKEN=<YOUR_PULUMI_ACCESS_TOKEN> \
  -e AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID> \
  -e AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY> \
  -e AWS_REGION=us-east-2 \
  -e QOVERY_ENVIRONMENT_ID=1234567890 \
  aws-ec2-with-pulumi \
  -c "pulumi stack select -c -s \$QOVERY_ENVIRONMENT_ID && pulumi up -y"
```

To delete your application:

```shell
docker run \
  -e PULUMI_ACCESS_TOKEN=<YOUR_PULUMI_ACCESS_TOKEN> \
  -e AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID> \
  -e AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY> \
  -e AWS_REGION=us-east-2 \
  -e QOVERY_ENVIRONMENT_ID=1234567890 \
  aws-ec2-with-pulumi \
  -c "pulumi stack select -c -s \$QOVERY_ENVIRONMENT_ID && pulumi destroy -y"
```

## Qovery

To inject back environment variables via Qovery Lifecycle Job output:

Start Event CMD Arguments:
```shell
["-c", "pulumi stack select -c -s \$QOVERY_ENVIRONMENT_ID && pulumi up -y"]
```

End Event CMD Arguments:
```shell
["-c", "pulumi stack select -c -s \$QOVERY_ENVIRONMENT_ID && pulumi destroy -y"]
```
