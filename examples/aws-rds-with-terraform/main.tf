terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "rds_instance" {
  db_instance_identifier = "myDbName${split("-", var.qovery_environment_id)[0]}"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0.39"
  instance_class         = "db.t2.micro"
  username               = var.username
  password               = length(trimspace(var.password)) > 0 ? var.password : random_password.password.result
  publicly_accessible    = true
  skip_final_snapshot    = true

  tags = {
    ttl = 15552000
  }
}
