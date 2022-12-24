variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "terraform_backend_bucket" {
  type    = string
  # TODO change this to your bucket name
  default = "qovery-demo-terraform-states" # Name of the Backend S3 bucket
}

variable "terraform_backend_key" {
  type    = string
  default = "test" # Name of the Backend S3 key
}

variable "aws_access_key_id" {
  type    = string
  default = "your AWS access key id"
}

variable "aws_secret_access_key" {
  type    = string
  default = "your AWS secret access key"
}

variable "qovery_environment_id" {
  type    = string
  default = "1234567890"
}
