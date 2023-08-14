output "database_server_address" {
  description = "AWS RDS instance endpoint"
  value       = aws_db_instance.default[*].address
}

output "database_resource_id" {
  description = "Resource ID within the AWS RDS instance"
  value       = aws_db_instance.default[*].resource_id
}

output "database_name" {
  description = "Database name within the AWS RDS instance"
  value       = aws_db_instance.default[*].db_name
}

output "database_port" {
  description = "Database port used by the AWS RDS instance"
  value       = aws_db_instance.default[*].port
}

output "database_username" {
  description = "Username to authenticate in the database server"
  value       = aws_db_instance.default[*].username
}

output "database_password" {
  description = "Password to authenticate in the database server"
  value       = aws_db_instance.default[*].password
}

output "database_engine" {
  description = "Type of database engine provisioned: mysql, postgres,..."
  value       = aws_db_instance.default[*].engine
}
