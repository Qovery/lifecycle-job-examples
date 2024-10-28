terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      #version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# Get EKS cluster info
data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${var.eks_cluster_name}"
  description = "Security group for RDS instance"
  vpc_id      = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id

  # Allow inbound MySQL traffic from EKS cluster
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group-${var.eks_cluster_name}"
  }
}

# DB subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group-${var.eks_cluster_name}"
  subnet_ids = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids

  tags = {
    Name = "RDS subnet group for ${var.eks_cluster_name}"
  }
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
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    ttl = 15552000
  }
}

# IAM role for RDS enhanced monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role-${var.eks_cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}