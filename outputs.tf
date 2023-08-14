
# General output
output "region" {
  description = "AWS Region where the cluster is provisioned"
  value       = module.vpc.region
}

# Kubernetes cluster
output "cluster_name" {
  description = "Kubernetes cluster name"
  value       = local.cluster_name
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
  value = {
    for key, value in module.databases : key => value.database_server_address
  }
}

output "database_name" {
  description = "RDS database name"
  value = {
    for key, value in module.databases : key => value.database_name
  }
}

output "database_username" {
  description = "RDS database username"
  value = {
    for key, value in module.databases : key => value.database_username
  }
}

output "database_password" {
  description = "RDS database password"
  sensitive   = true
  value = {
    for key, value in module.databases : key => value.database_password
  }
}

# Filestorage ouput
output "filestorage_endpoint" {
  description = "S3 endpoint"
  value       = module.file_storage.filestorage_endpoint
}

output "filestorage_regional_endpoint" {
  description = "S3 regional endpoint"
  value       = module.file_storage.filestorage_regional_endpoint
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
  description = "Route 53 hosted zone ID"
  value       = aws_route53_zone.cluster_dns.id
}

output "aws_route53_zone_name_servers" {
  description = "Route 53 hosted zone nameservers"
  value       = aws_route53_zone.cluster_dns.name_servers
}
