# Create and Destroy an GCP PosgreSQL Instance with Terraform

This example shows how to create and destroy an PostgreSQL instance with Terraform and Qovery Lifecycle Job.

> This example is part of this complete guide: [Create and Destroy an GCP PostgreSQL instance with Terraform](https://hub.qovery.com/guides/tutorial/how-to-use-lifecycle-job-to-deploy-any-kind-of-resources/).

## How to test it locally

### Setup

First, you need to set the following environment variable:
- `GOOGLE_APPLICATION_CREDENTIALS`: the path containing the GCP credentials (json file)

Then modify the file `terraform.tfvars` to match your needs:
- `project_id` = The project ID to deploy to
- `region` = The region to deploy to
- `vpc_name` = Name of the VPC to use to install the database ()
- `subnet_name` = Name of the subnet to install the database
- `database_instance_name` = The database instance name
- `database_name` = The database name
- `database_version` = The database version you want to use

Then, you can run the following commands:

```shell
terraform plan
```

### To deploy your instance

```shell
terraform apply
```


### To destroy your RDS instance

```shell
terraform destroy
```

## How to use it on Qovery

### Setup and Deploy

1. Fork this project
2. Create a new Service of type "Terraform"
3. Set the following working root path: `/examples/gcp-deploy-postgresql`
4. Skip the Docker, Triggers and Resources sections
5. At the environment variables step:
   - for the existing `TF_VAR`: fill here the values you want to use for the tfvar file
   - create a new environment variable of type `File` called `GOOGLE_APPLICATION_CREDENTIALS`, path: `tmp/data/terraform/terraform.tfvars`, value: put here the content of the json credentials from GCP
6. Create and deploy the job

### How to use it from another application

After the execution of the job, a few environment variables will be automatically created which contains the connection parameters to the database.

Go to the environment variable section of your environment and create an alias for each of them to match the syntax expected by your application.

### How to destroy it

Delete the resource on Qovery, it will trigger a `trigger destroy` command and remove the resource from your GCP account.