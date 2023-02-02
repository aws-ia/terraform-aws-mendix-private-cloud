
output "region" {
  description = "AWS Region where the cluster is provisioned"
  value       = module.mendix_private_cloud_example.region
}

output "cluster_name" {
  description = "Kubernetes cluster name"
  value       = module.mendix_private_cloud_example.cluster_name
}
