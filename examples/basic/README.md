<!-- BEGIN_TF_DOCS -->
## Provisionning
Retrieve the cluster\_id and cluster\_secret on https://privatecloud.mendixcloud.com
```
aws_region=""
domain_name=""
certificate_expiration_email=""
s3_bucket_name=""
cluster_id=""
cluster_secret=""
mendix_operator_version="2.10.0"

terraform init

terraform apply -auto-approve -var cluster_id=${cluster_id} -var cluster_secret=${cluster_secret} -var mendix_operator_version=${mendix_operator_version} -var aws_region=${aws_region} -var domain_name=${domain_name} -var certificate_expiration_email=${certificate_expiration_email} -var s3_bucket_name=${s3_bucket_name}
```

## Clean up
```
terraform destroy -target="module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons.module.ingress_nginx[0].module.helm_addon.helm_release.addon[0]" -auto-approve
terraform destroy -target="module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons.module.ingress_nginx[0].kubernetes_namespace_v1.this[0]" -auto-approve
terraform destroy -target="module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons.module.prometheus[0].module.helm_addon.helm_release.addon[0]" -auto-approve
terraform destroy -target="module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons.module.prometheus[0].kubernetes_namespace_v1.prometheus[0]" -auto-approve
terraform destroy -target="module.mendix_private_cloud_example.module.monitoring.helm_release.loki" -auto-approve
terraform destroy -target="module.mendix_private_cloud_example.module.monitoring.kubernetes_namespace.loki" -auto-approve
terraform destroy -target="module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons" -auto-approve
terraform destroy -target="module.mendix_private_cloud_example.module.eks_blueprints" -auto-approve
terraform destroy -target="module.mendix_private_cloud_example.module.vpc" -auto-approve
terraform destroy -auto-approve
```

## Test
```
go test -timeout 60m -v test/examples_basic_test.go
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.35 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mendix_private_cloud_example"></a> [mendix\_private\_cloud\_example](#module\_mendix\_private\_cloud\_example) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region name | `string` | n/a | yes |
| <a name="input_certificate_expiration_email"></a> [certificate\_expiration\_email](#input\_certificate\_expiration\_email) | Let's Encrypt certificate expiration email | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Mendix Private Cloud Cluster ID | `string` | n/a | yes |
| <a name="input_cluster_secret"></a> [cluster\_secret](#input\_cluster\_secret) | Mendix Private Cloud Cluster Secret | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket name | `string` | n/a | yes |
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of IP adresses allowed to access EKS cluster endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_environments_internal_names"></a> [environments\_internal\_names](#input\_environments\_internal\_names) | List of internal environments names | `list(string)` | <pre>[<br>  "app1",<br>  "app2",<br>  "app3"<br>]</pre> | no |
| <a name="input_mendix_operator_version"></a> [mendix\_operator\_version](#input\_mendix\_operator\_version) | Mendix Private Cloud Operator Version | `string` | `"2.10.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_region"></a> [region](#output\_region) | AWS region where the cluster is provisioned |
<!-- END_TF_DOCS -->