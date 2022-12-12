output "container_registry_hostname" {
  description = "Elatic Container Registry hostname"
  value       = trimsuffix(aws_ecr_repository.mendix_ecr.repository_url, format("/%s", aws_ecr_repository.mendix_ecr.name))
}

output "container_registry_name" {
  description = "Elatic Container Registry name"
  value       = aws_ecr_repository.mendix_ecr.name
}

output "container_irsa_role_arn" {
  description = "Elatic Container Registry IAM Role ARN"
  value       = aws_iam_role.ecr_irsa_role.arn
}
