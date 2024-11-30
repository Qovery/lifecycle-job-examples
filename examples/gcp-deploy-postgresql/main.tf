terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "google" {
  project = var.project_id
  region  = var.region
}


# Existing VPC configuration
data "google_compute_network" "existing_vpc" {
  name = var.vpc_name
}

data "google_compute_subnetwork" "existing_subnet" {
  name   = var.subnet_name
  region = var.region
}

# Private IP configuration
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-${var.database_instance_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.existing_vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.existing_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# Random password generation for database users
resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Cloud SQL Instance
resource "google_sql_database_instance" "postgres" {
  name                = var.database_instance_name
  database_version    = var.database_version
  region             = var.region
  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.instance_tier
    availability_type = "REGIONAL"  # High availability
    disk_size         = var.disk_size_gb  # GB
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    disk_autoresize_limit = 0  # No limit

    database_flags {
      name  = "max_connections"
      value = "1000"
    }

    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    database_flags {
      name  = "log_min_duration_statement"
      value = "1000"  # Log queries taking more than 1 second
    }

    database_flags {
      name  = "log_temp_files"
      value = "0"  # Log all temporary files
    }

    database_flags {
      name  = "log_min_messages"
      value = "warning"
    }

    database_flags {
      name  = "ssl_min_protocol_version"
      value = "TLSv1.2"
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.existing_vpc.id
      require_ssl     = false
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "02:00"  # UTC time
      backup_retention_settings {
        retained_backups = 30  # Keep backups for 30 days
        retention_unit   = "COUNT"
      }
    }

    maintenance_window {
      day          = 7    # Sunday
      hour         = 3    # 3 AM UTC
      update_track = "stable"
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length    = 1024
      record_application_tags = true
      record_client_address  = true
    }
  }
}

# Primary database
resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.postgres.name
  charset  = "UTF8"
}

# Database users
resource "google_sql_user" "application" {
  name     = "app_user"
  instance = google_sql_database_instance.postgres.name
  password = random_password.db_password.result
}

# Read-only user for reporting
resource "google_sql_user" "readonly" {
  name     = "readonly_user"
  instance = google_sql_database_instance.postgres.name
  password = random_password.db_password.result
}