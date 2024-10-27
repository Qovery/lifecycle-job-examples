variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "The AWS RDS region"
}

variable "aws_access_key_id" {
  type        = string
  description = "The AWS RDS access key ID"
}

variable "aws_secret_access_key" {
  type        = string
  description = "The AWS RDS secret access key"
}

variable "qovery_environment_id" {
  type        = string
  description = "The Qovery environment ID"
}

variable "username" {
  type        = string
  description = "The username for the RDS instance"
  default     = "myuser"
}

variable "password" {
  type        = string
  description = "The password for the RDS instance - leave empty to generate a random password"
  default     = ""
}