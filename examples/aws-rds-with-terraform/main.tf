terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {}

  required_version = ">= 0.14.9"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}


resource "aws_db_instance" "rds_instance" {
  allocated_storage   = 20
  identifier          = "rds-terraform"
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0.27"
  instance_class      = "db.t2.micro"
  name                = "myDbName${split("-", var.qovery_environment_id)[0]}"
  username            = "yourDbUsername"
  password            = "yourPassword"
  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    ttl = 15552000
  }
}
