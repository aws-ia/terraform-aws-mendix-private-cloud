
# General output
output "region" {
  description = "AWS region where the cluster is provisioned"
  value       = module.vpc.region
}

# Kubernetes cluster
output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.vpc.cluster_name
}

output "vpc_private_subnets" {
  description = "VPC private subnets"
  value       = module.vpc.vpc_private_subnets
}

output "vpc_public_subnets" {
  description = "VPC public subnets"
  value       = module.vpc.vpc_public_subnets
}

# Container Registry ECR output
output "container_registry_url" {
  description = "Elatic Container Registry URL"
  value       = module.container_registry.container_registry_hostname
}

output "container_registry_name" {
  description = "Elatic Container Registry name"
  value       = module.container_registry.container_registry_name
}

output "container_irsa_role_arn" {
  description = "Elatic Container Registry IAM Role ARN"
  value       = module.container_registry.container_irsa_role_arn
}

# Database output
output "database_server_address" {
  description = "RDS database address"
  value       = module.databases.database_server_address
}

output "database_name" {
  description = "RDS database name"
  value       = module.databases.database_name
}

output "database_port" {
  description = "RDS database port"
  value       = module.databases.database_port
}

output "database_username" {
  description = "RDS database username"
  value       = module.databases.database_username
}

output "database_password" {
  description = "RDS database password"
  sensitive   = true
  value       = module.databases.database_password
}

output "database_engine" {
  description = "RDS database engine"
  value       = module.databases.database_engine
}

# Filestorage ouput
output "filestorage_endpoint" {
  description = "S3 endpoint"
  value       = module.file_storage.filestorage_endpoint
}

output "filestorage_access_key" {
  description = "S3 access key"
  value       = module.file_storage.filestorage_access_key
}

output "filestorage_secret_key" {
  description = "S3 secret key"
  sensitive   = true
  value       = module.file_storage.filestorage_secret_key
}

# VPC output
output "cluster_vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

# Grafana output
output "grafana_admin_password" {
  description = "Grafana admin password"
  sensitive   = true
  value       = module.monitoring.grafana_admin_password
}

# Route53 output
output "aws_route53_zone" {
  description = "Route53 Hosted Zone ID"
  value       = aws_route53_zone.cluster_dns.id
}

output "aws_route53_zone_name_servers" {
  description = "Route53 Hosted Zone Nameservers"
  value       = aws_route53_zone.cluster_dns.name_servers
}
