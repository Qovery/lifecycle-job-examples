output "rds_instance_endpoint" {
  description = "The RDS connection endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}

output "rds_instance_username" {
  description = "The RDS master username"
  value       = aws_db_instance.rds_instance.username
}

output "rds_instance_password" {
  description = "The RDS master password"
  value       = aws_db_instance.rds_instance.password
  sensitive   = true
}
