output "rds_instance_endpoint" {
  description = "The RDS connection endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}
