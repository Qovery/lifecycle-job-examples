# Create and Destroy an AWS RDS Instance with Terraform

This example shows how to create and destroy an AWS RDS instance with Terraform and Qovery Lifecycle Job.

## How to use

To test locally this Terraform example, run the following commands:

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
