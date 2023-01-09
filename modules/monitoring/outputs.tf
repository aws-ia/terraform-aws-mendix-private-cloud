output "grafana_admin_password" {
  description = "Grafana admin password"
  sensitive   = true
  value       = aws_secretsmanager_secret_version.grafana.secret_string
}
