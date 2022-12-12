# file_storage

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.s3_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_kms_key.cmk_shared_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.apps_shared_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.apps_shared_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_public_access_block.apps_shared_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket name | `string` | n/a | yes |
| <a name="input_s3_user_name"></a> [s3\_user\_name](#input\_s3\_user\_name) | S3 user name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_filestorage_access_key"></a> [filestorage\_access\_key](#output\_filestorage\_access\_key) | S3 access key |
| <a name="output_filestorage_endpoint"></a> [filestorage\_endpoint](#output\_filestorage\_endpoint) | S3 endpoint |
| <a name="output_filestorage_regional_endpoint"></a> [filestorage\_regional\_endpoint](#output\_filestorage\_regional\_endpoint) | S3 regional endpoint |
| <a name="output_filestorage_secret_key"></a> [filestorage\_secret\_key](#output\_filestorage\_secret\_key) | S3 secret key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.s3_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_kms_key.cmk_shared_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.apps_shared_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.apps_shared_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_public_access_block.apps_shared_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket name | `string` | n/a | yes |
| <a name="input_s3_user_name"></a> [s3\_user\_name](#input\_s3\_user\_name) | S3 user name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_filestorage_access_key"></a> [filestorage\_access\_key](#output\_filestorage\_access\_key) | S3 access key |
| <a name="output_filestorage_endpoint"></a> [filestorage\_endpoint](#output\_filestorage\_endpoint) | S3 endpoint |
| <a name="output_filestorage_regional_endpoint"></a> [filestorage\_regional\_endpoint](#output\_filestorage\_regional\_endpoint) | S3 regional endpoint |
| <a name="output_filestorage_secret_key"></a> [filestorage\_secret\_key](#output\_filestorage\_secret\_key) | S3 secret key |
<!-- END_TF_DOCS -->