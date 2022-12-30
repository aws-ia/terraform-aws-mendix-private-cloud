<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.35 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.mendix_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_role.ecr_irsa_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecr_irsa_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account ID | `string` | n/a | yes |
| <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider) | The OpenID Connect identity provider (issuer URL without leading `https://`) | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region name | `string` | n/a | yes |
| <a name="input_registry_repository_name"></a> [registry\_repository\_name](#input\_registry\_repository\_name) | ECR repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_irsa_role_arn"></a> [container\_irsa\_role\_arn](#output\_container\_irsa\_role\_arn) | Elatic Container Registry IAM Role ARN |
| <a name="output_container_registry_hostname"></a> [container\_registry\_hostname](#output\_container\_registry\_hostname) | Elatic Container Registry hostname |
| <a name="output_container_registry_name"></a> [container\_registry\_name](#output\_container\_registry\_name) | Elatic Container Registry name |
<!-- END_TF_DOCS -->