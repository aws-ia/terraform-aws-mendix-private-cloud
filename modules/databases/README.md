<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.35 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.35 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.rds_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#input\_cluster\_primary\_security\_group\_id) | VPC primary security group ID | `string` | n/a | yes |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | VPC identifierD | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | VPC subnets | `list(string)` | n/a | yes |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | RDS Instance class | `string` | `"db.t3.micro"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_engine"></a> [database\_engine](#output\_database\_engine) | Type of database engine provisioned: mysql, postgres,... |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | Database name within the AWS RDS instance |
| <a name="output_database_password"></a> [database\_password](#output\_database\_password) | Password to authenticate in the database server |
| <a name="output_database_port"></a> [database\_port](#output\_database\_port) | Database port used by the AWS RDS instance |
| <a name="output_database_server_address"></a> [database\_server\_address](#output\_database\_server\_address) | AWS RDS instance endpoint |
| <a name="output_database_username"></a> [database\_username](#output\_database\_username) | Username to authenticate in the database server |
<!-- END_TF_DOCS -->