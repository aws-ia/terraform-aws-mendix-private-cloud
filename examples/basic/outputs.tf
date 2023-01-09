
output "region" {
  description = "AWS region where the cluster is provisioned"
  value       = module.mendix_private_cloud_example.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.mendix_private_cloud_example.cluster_name
}
