# Outputs
output "database_user" {
  value     = google_sql_user.application.name
  sensitive = true
}
output "database_password" {
  value     = google_sql_user.application.password
  sensitive = true
}

output "database_name" {
  value     = var.database_name
  description = "The name of the created databas"
  sensitive = true
}

output "database_private_ip" {
  description = "The private IP address of the PostgreSQL instance"
  value       = google_sql_database_instance.postgres.private_ip_address
}