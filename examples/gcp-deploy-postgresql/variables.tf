# Variables
variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name of the VPC to use to install the database"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet to install the database"
  type        = string
}

variable "database_instance_name" {
  description = "The database instance name"
  type        = string
}

variable "database_name" {
  description = "The database name"
  type        = string
}

variable "database_version" {
  description = "The PostgreSQL version to use"
  type        = string
  default     = "POSTGRES_15"  # Latest stable version as of 2024
}

variable "instance_tier" {
  description = "The machine type to use"
  type        = string
  default     = "db-g1-small"  # 4 vCPUs, 15GB RAM - adjust based on needs
}

variable "disk_size_gb" {
  description = "The size of the disk to use in GB"
  type        = string
  default     = "10"  # 10 GB, adjust based on needs
}