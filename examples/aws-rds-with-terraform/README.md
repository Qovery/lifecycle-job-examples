# Create and Destroy an AWS RDS Instance with Terraform

This example shows how to create and destroy an AWS RDS instance with Terraform and Qovery Lifecycle Job.

> This example is part of this complete guide: [Create and Destroy an AWS RDS Instance with Terraform](https://hub.qovery.com/guides/tutorial/how-to-use-lifecycle-job-to-deploy-any-kind-of-resources/).

## How to test it

First, you need to set the following environment variables:
- `TF_VAR_terraform_backend_bucket`: your name of the S3 bucket used to store the Terraform state (you must create the bucket)
- `TF_VAR_aws_access_key_id`: your AWS access key ID
- `TF_VAR_aws_secret_access_key`: your AWS secret access key
- `TF_VAR_aws_region`: your AWS region
- `TF_VAR_qovery_environment_id`: your Qovery environment ID (you can put a random alphanumeric value for local testing)

Then, you can run the following commands:

```shell
docker build \
  --build-arg TF_VAR_terraform_backend_bucket=<YOUR_S3_TERRAFORM_BACKEND_BUCKET_NAME> \
  --build-arg TF_VAR_aws_access_key_id=<YOUR_AWS_ACCESS_KEY_ID> \ 
  --build-arg TF_VAR_aws_secret_access_key=<YOUR_AWS_SECRET_ACCESS_KEY> \
  --build-arg TF_VAR_aws_region=us-east-2 \
  \ -t aws-rds-terraform .
```

### To deploy your RDS instance

```shell
docker run \
  -e TF_VAR_aws_access_key_id=<YOUR_ACCESS_KEY_ID> \
  -e TF_VAR_aws_secret_access_key=<YOUR_SECRET_ACCESS_KEY> \
  -e TF_VAR_aws_region=us-east-2 \
  -it --entrypoint /bin/sh aws-rds-terraform \
  -c "terraform plan && terraform apply -auto-approve && terraform output -json"
```

### To destroy your RDS instance

```shell
docker run \
  -e TF_VAR_aws_access_key_id=<YOUR_ACCESS_KEY_ID> \
  -e TF_VAR_aws_secret_access_key=<YOUR_SECRET_ACCESS_KEY> \
  -e TF_VAR_aws_region=us-east-2 \
  -it --entrypoint /bin/sh  aws-rds-terraform \
  -c "terraform plan && terraform destroy -auto-approve"
```

## How to use it on Qovery

1. Fork this project
2. [Create a new Lifecycle Job](https://hub.qovery.com/docs/using-qovery/configuration/lifecycle-job/)
3. Set the following working root path: `/examples/aws-rds-with-terraform`
4. Set the following environment variables:
   - `TF_VAR_terraform_backend_bucket`: your name of the S3 bucket used to store the Terraform state (you must create the bucket)
   - `TF_VAR_aws_access_key_id`: your AWS access key ID
   - `TF_VAR_aws_secret_access_key`: your AWS secret access key
   - `TF_VAR_aws_region`: your AWS region
   - `TF_VAR_qovery_environment_id`: your Qovery environment ID (you can put a random alphanumeric value for local testing)
5. Set the following command:
    - To deploy your RDS instance: `["-c", "terraform plan && terraform apply -auto-approve && terraform output -json > /qovery-output/qovery-output.json"]`
    - To destroy your RDS instance: `["-c", "terraform plan && terraform destroy -auto-approve"]`
