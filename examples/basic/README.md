<!-- BEGIN_TF_DOCS -->
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
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of IP adresses allowed to access EKS cluster endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region name | `string` | n/a | yes |
| <a name="input_certificate_expiration_email"></a> [certificate\_expiration\_email](#input\_certificate\_expiration\_email) | Let's Encrypt certificate expiration email | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Mendix Private Cloud Cluster ID | `string` | n/a | yes |
| <a name="input_cluster_secret"></a> [cluster\_secret](#input\_cluster\_secret) | Mendix Private Cloud Cluster Secret | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name | `string` | n/a | yes |
| <a name="input_mendix_operator_version"></a> [mendix\_operator\_version](#input\_mendix\_operator\_version) | Mendix Private Cloud Operator Version | `string` | `"2.9.0"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_region"></a> [region](#output\_region) | AWS region where the cluster is provisioned |
<!-- END_TF_DOCS --><!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of IP adresses allowed to access EKS cluster endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region name | `string` | n/a | yes |
| <a name="input_certificate_expiration_email"></a> [certificate\_expiration\_email](#input\_certificate\_expiration\_email) | Let's Encrypt certificate expiration email | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Mendix Private Cloud Cluster ID | `string` | n/a | yes |
| <a name="input_cluster_secret"></a> [cluster\_secret](#input\_cluster\_secret) | Mendix Private Cloud Cluster Secret | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name | `string` | n/a | yes |
| <a name="input_mendix_operator_version"></a> [mendix\_operator\_version](#input\_mendix\_operator\_version) | Mendix Private Cloud Operator Version | `string` | `"2.9.0"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_region"></a> [region](#output\_region) | AWS region where the cluster is provisioned |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
