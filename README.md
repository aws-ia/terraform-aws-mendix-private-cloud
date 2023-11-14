<!-- BEGIN_TF_DOCS -->
# Mendix Partner Solution for Amazon EKS—Terraform module

This Amazon Web Services (AWS) Partner Solution uses a [Terraform module](https://registry.terraform.io/modules/aws-ia/mendix-private-cloud/aws/latest) to deploy an infrastructure that meets the requirements of [Mendix for Private Cloud](https://www.mendix.com/evaluation-guide/app-lifecycle/mendix-for-private-cloud/). You deploy this solution in an automated way using Amazon Elastic Kubernetes Service (Amazon EKS). The infrastructure is for users of the Mendix application-development platform who want to deploy and manage Mendix apps in the AWS Cloud.

For more information, refer to the [Mendix documentation](https://docs.mendix.com/). If you have questions, feedback, or ideas, you can post them in the [Mendix Forum about AWS](https://forum.mendix.com/link/space/aws).

This Partner Solution was developed by Siemens in collaboration with AWS. Siemens is an [AWS Partner](https://partners.amazonaws.com/partners/001E000000YMRQTIA5/Siemens%20Digital%20Industries%20Software). Mendix is a wholly owned subsidiary of Siemens.

## Costs and licenses

To use Mendix, you must have an operator license. For more information, refer to [Licensing Mendix for Private Cloud](https://docs.mendix.com/developerportal/deploy/private-cloud/#licensing).

There is no cost to use this Partner Solution, but you'll be billed for any AWS services or resources that this Partner Solution deploys. For more information, refer to the [AWS Partner Solution General Information Guide](https://fwd.aws/rA69w?).

## Architecture

This Partner Solution deploys into a new virtual private cloud (VPC).

![Architecture for Mendix on Amazon EKS](https://raw.githubusercontent.com/aws-ia/terraform-aws-mendix-private-cloud/main/doc/deployment_guide/images/terraform-mendix-private-cloud-diagram.png)

As shown in the diagram, this solution sets up the following:

* A highly available architecture that spans three Availability Zones.
* A VPC configured with public and private subnets, according to AWS best practices, to provide you with your own virtual network on AWS.
* An Amazon Route 53 public hosted zone that routes incoming internet traffic.
* In the public subnets, managed NAT gateways to allow outbound internet access for resources in the private subnet.
* In the private subnets, Amazon EKS clusters—each with three Kubernetes nodes—inside an Auto Scaling group. Each node is an Amazon Elastic Compute Cloud (Amazon EC2) instance. Each cluster contains the following (not shown):
    * Mendix apps and components.
    * Cert-manager.
    * An open-source logging and monitoring solution with Grafana, AWS managed Prometheus, OpenTelemetry, CloudWatch, and Fluent Bit.
    * ExternalDNS, which synchronizes exposed Kubernetes services and ingresses with Route 53.
* A Network Load Balancer to distribute traffic across the Kubernetes nodes.
* Amazon Simple Storage Service (Amazon S3) to store the files.
* Amazon Elastic Block Store (Amazon EBS) to provide storage for Grafana.
* Amazon Relational Database Service (Amazon RDS) for PostgreSQL to store Mendix application data.
* Amazon Elastic Container Registry (Amazon ECR) to provide a private registry.
* AWS Key Management Service (AWS KMS) to provide an encryption key for Amazon RDS, Amazon EBS, and AWS Secrets Manager.
* Secrets Manager to replace hardcoded credentials, including passwords, with an API call.

## Prerequisites

Before you can provision your Mendix environments on Amazon EKS, you must install and configure the required tools, configure Mendix Private Cloud, and configure Terraform.

### Install and configure the required tools

1. Install the latest version of [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2. Configure an IAM user with programmatic access and at least [the following IAM permissions](https://github.com/aws-ia/terraform-mendix-private-cloud/blob/main/deployment-policy.json).

3. Install the latest version of [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
4. Run `aws configure` to configure AWS CLI with the `ACCESS_KEY_ID`, `SECRET_ACCESS_KEY`, and `REGION` corresponding to your IAM user.
5. Install the latest version of [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html).
6. Install the latest version of [kubectl](https://kubernetes.io/docs/tasks/tools/).
7. Download [GNU Wget](https://www.gnu.org/software/wget/) (required for the Terraform EKS module).

### Configure Mendix Private Cloud

1. Confirm that your [Mendix Runtime](https://docs.mendix.com/refguide/runtime/) version is 9.21 or newer.
2. Create your Mendix app. For more information, refer to [Deploying a Mendix App to a Private Cloud Cluster](https://docs.mendix.com/developerportal/deploy/private-cloud-deploy/).
3. Register a new EKS cluster. For more information, refer to [Creating a Cluster and Namespace](https://docs.mendix.com/developerportal/deploy/private-cloud-cluster/#create-cluster).
4. [Add a new connected namespace](https://docs.mendix.com/developerportal/deploy/private-cloud-cluster/#add-namespace) called *mendix*.
5. Retrieve the cluster ID and the cluster secret in the [Installation tab](https://docs.mendix.com/developerportal/deploy/private-cloud-cluster/#download-configuration-tool) for your namespace.

### Configure Terraform

1. Provision an S3 bucket with your desired name and an Amazon DynamoDB table with the partition key `LockID` (string type) to store the state file and have a locking mechanism, respectively.
2. Edit `providers.tf`, filling in your information, as in the following example:

    ```
    terraform {
      backend "s3" {
        region         = "eu-central-1"
        bucket         = "state-bucket-state"
        key            = "terraform.tfstate"
        dynamodb_table = "dynamodb-table-state"
        encrypt        = true
      }
    ```

3. Edit `terraform.tfvars`, filling in your information, as in the following example:

    ```
    aws_region                   = ""
    domain_name                  = "project-name-example.com"
    certificate_expiration_email = "example@example.com"
    s3_bucket_name               = "project-name"
    namespace_id                 = ""
    namespace_secret             = ""
    environments_internal_names  = ["app1", "app2", "app3"]
    ```

The number of applications deployed is handled by the `environments_internal_names` variable. Internal names are used during the environment creation, as shown here:

![Customizing the environment name](https://raw.githubusercontent.com/aws-ia/terraform-aws-mendix-private-cloud/main/doc/deployment_guide/images/environments_internal_names.png)

The internal name must match the name that you specify in the `environments_internal_names` variable when you create your Mendix app.

## Provision a new environment

1. Run the following commands:

    ```
    terraform init
    terraform apply
    ```

2. After everything has been provisioned, run the following command to retrieve the access credentials for your new cluster and automatically configure kubectl:

    ```
    aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
    ```

3. Retrieve the *aws\_route53\_zone\_name\_servers* that were generated using the AWS Console. To do so, either choose **Route53** > **Hosted Zone** or run the following command:

    ```
    terraform output aws_route53_zone_name_servers
    ```

4. Depending on your provider, update **External Domain Name Registrar** or **Route53 registered domain** with the *aws\_route53\_zone\_name\_servers* values. For more information, refer to [Configuring Amazon Route 53 as your DNS service](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring.html).

5. If you're deploying more than three apps, change the default instance type of the `eks_node_instance_type` variable. By default, the instance type for the Kubernetes nodes is optimized to support up to three apps. Deploying more than three apps with the default instance type may affect the performance of your applications. For more information, refer to [Choosing an Amazon EC2 instance type](https://docs.aws.amazon.com/eks/latest/userguide/choosing-instance-type.html) in the Amazon EKS User Guide.

## Security

### Cluster endpoint

Kubernetes API requests within your cluster's VPC (such as node to control plane communication) use the private VPC endpoint.

Your cluster API server is accessible from the internet. If required, you can limit the CIDR blocks that can access the public endpoint by configuring the `allowed_ips` variable. For more information, refer to [Amazon EKS cluster endpoint access control](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html).

### Encryption

All the EBS volumes, the RDS PostgreSQL database, and the S3 storage bucket are encrypted at rest. The end-to-end TLS encryption is handled at the Ingress NGINX Controller level. A certificate is generated for each app by *cert-manager*, configured with a *Let’s Encrypt* certificate issuer.

## Automatic scaling

While all the Amazon EKS nodes are placed in an Auto Scaling group, the [Kubernetes Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) is not installed by default. The Cluster Autoscaler automatically
scales up and down by allowing Kubernetes to modify the Amazon EC2 Auto Scaling groups.

## Logging and monitoring

A basic logging and monitoring stack containing Grafana, AWS managed Prometheus, OpenTelemetry, CloudWatch, and Fluent Bit is available at the following URL: `https://monitoring.{domain_name}`

To retrieve the Grafana administrative credentials (with `admin` username), run the following command:

```
terraform output -json grafana_admin_password
```

## Troubleshooting

If you encounter any issues while provisioning your Mendix environments on AWS, use the following troubleshooting tips.

### The Terraform Registry does not have a package available (Mac)

When initializing Terraform, Apple M1 users may encounter the following error:

```
│ Provider Terraform Registry 38 v2.2.0 does not have a
│ package available for your current platform, darwin_arm64
```
**Solution:** Install [m1-terraform-provider-helper](https://github.com/kreuzwerker/m1-terraform-provider-helper):

```
brew install kreuzwerker/taps/m1-terraform-provider-helper
m1-terraform-provider-helper activate
m1-terraform-provider-helper install hashicorp/template -v v2.2.0
```

### My cluster never connects

In the Mendix Private Cloud portal, in the Cluster Manager, the status of your cluster is shown as **Waiting for Connection**, but the cluster never connects.

**Cause:** The Mendix Agent or the Mendix Operator may not be configured correctly or may not be connected.

**Solution:** Perform the following steps:

1. Retrieve the logs of the installer job by running the following command:

    ```
    kubectl logs job.batch/mxpc-cli-installer -n mendix
    ```

    You should receive the following output:

    ```
    -- Done-- Applying Kubernetes Secrets... Done!
    -- Applying Service Accounts... Done!
    -- Applying Storage Plans... Done!
    -- Applying Operator Patches... Done!
    -- Successfully applied all the configuration!
    operatorconfiguration.privatecloud.mendix.com/mendix-operator-configuration patched
    operatorconfiguration.privatecloud.mendix.com/mendix-operator-configuration patched
    operatorconfiguration.privatecloud.mendix.com/mendix-operator-configuration patched
    ```

2. Reinstall the installer by running the following command:

    ```
    terraform destroy -target=helm_release.mendix_installer
    terraform plan; terraform apply --auto-approve
    ```

## Cleanup

Before cleaning up, make sure that you have deleted Mendix App environments.
Otherwise, you will need to manually remove some finalizers in the namespace and detach some roles from policies in AWS IAM.

To clean up your environment, run the following commands:

```
terraform destroy -target="module.eks_blueprints_kubernetes_addons.module.ingress_nginx.helm_release.this[0]" -auto-approve
terraform destroy -target="module.eks_blueprints_kubernetes_addons.module.kube_prometheus_stack.helm_release.this[0]" -auto-approve
terraform destroy -target="module.eks_blueprints_kubernetes_addons.module.aws_load_balancer_controller.helm_release.this[0]" -auto-approve
terraform destroy -target="module.eks_blueprints_kubernetes_addons" -auto-approve
terraform destroy -auto-approve
```

## License

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Customer responsibility

After you deploy this Partner Solution, confirm that your resources and services are updated and configured—including any required patches—to meet your security and other needs. For more information, refer to the [AWS Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.10 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.7.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.10 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.7.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.16.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_container_registry"></a> [container\_registry](#module\_container\_registry) | ./modules/container-registry | n/a |
| <a name="module_databases"></a> [databases](#module\_databases) | ./modules/databases | n/a |
| <a name="module_ebs_csi_driver_irsa"></a> [ebs\_csi\_driver\_irsa](#module\_ebs\_csi\_driver\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.20 |
| <a name="module_eks_blueprints"></a> [eks\_blueprints](#module\_eks\_blueprints) | terraform-aws-modules/eks/aws | ~> 19.13 |
| <a name="module_eks_blueprints_kubernetes_addons"></a> [eks\_blueprints\_kubernetes\_addons](#module\_eks\_blueprints\_kubernetes\_addons) | aws-ia/eks-blueprints-addons/aws | ~> 1.8.0 |
| <a name="module_file_storage"></a> [file\_storage](#module\_file\_storage) | ./modules/file-storage | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.aws_for_fluentbit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ebs_encryption_by_default.ebs_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default) | resource |
| [aws_eks_addon.adot_addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_iam_policy.environment_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.provisioner_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.storage_provisioner_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_route53_zone.cluster_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [helm_release.mendix_installer](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.mendix](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_string.random_eks_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name | `string` | n/a | yes |
| <a name="input_certificate_expiration_email"></a> [certificate\_expiration\_email](#input\_certificate\_expiration\_email) | Let's Encrypt certificate expiration email | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name | `string` | n/a | yes |
| <a name="input_namespace_id"></a> [namespace\_id](#input\_namespace\_id) | Mendix Private Cloud Namespace ID | `string` | n/a | yes |
| <a name="input_namespace_secret"></a> [namespace\_secret](#input\_namespace\_secret) | Mendix Private Cloud Namespace Secret | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket name | `string` | n/a | yes |
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of IP adresses allowed to access EKS cluster endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_eks_cluster_name_prefix"></a> [eks\_cluster\_name\_prefix](#input\_eks\_cluster\_name\_prefix) | EKS name prefix for the new cluster | `string` | `"mendix-eks"` | no |
| <a name="input_eks_node_instance_type"></a> [eks\_node\_instance\_type](#input\_eks\_node\_instance\_type) | EKS instance type | `string` | `"t3.medium"` | no |
| <a name="input_environments_internal_names"></a> [environments\_internal\_names](#input\_environments\_internal\_names) | List of internal environments names | `list(string)` | <pre>[<br>  "app1"<br>]</pre> | no |
| <a name="input_mendix_operator_version"></a> [mendix\_operator\_version](#input\_mendix\_operator\_version) | Mendix Private Cloud Operator version | `string` | `"2.13.0"` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | The version of Postgres that terraform would create. | `string` | `"14.8"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_route53_zone"></a> [aws\_route53\_zone](#output\_aws\_route53\_zone) | Route 53 hosted zone ID |
| <a name="output_aws_route53_zone_name_servers"></a> [aws\_route53\_zone\_name\_servers](#output\_aws\_route53\_zone\_name\_servers) | Route 53 hosted zone nameservers |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes cluster name |
| <a name="output_cluster_vpc_id"></a> [cluster\_vpc\_id](#output\_cluster\_vpc\_id) | VPC ID |
| <a name="output_container_irsa_role_arn"></a> [container\_irsa\_role\_arn](#output\_container\_irsa\_role\_arn) | Elatic Container Registry IAM Role ARN |
| <a name="output_container_registry_name"></a> [container\_registry\_name](#output\_container\_registry\_name) | Elatic Container Registry name |
| <a name="output_container_registry_url"></a> [container\_registry\_url](#output\_container\_registry\_url) | Elatic Container Registry URL |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | RDS database name |
| <a name="output_database_password"></a> [database\_password](#output\_database\_password) | RDS database password |
| <a name="output_database_server_address"></a> [database\_server\_address](#output\_database\_server\_address) | RDS database address |
| <a name="output_database_username"></a> [database\_username](#output\_database\_username) | RDS database username |
| <a name="output_filestorage_endpoint"></a> [filestorage\_endpoint](#output\_filestorage\_endpoint) | S3 endpoint |
| <a name="output_filestorage_regional_endpoint"></a> [filestorage\_regional\_endpoint](#output\_filestorage\_regional\_endpoint) | S3 regional endpoint |
| <a name="output_grafana_admin_password"></a> [grafana\_admin\_password](#output\_grafana\_admin\_password) | Grafana admin password |
| <a name="output_region"></a> [region](#output\_region) | AWS Region where the cluster is provisioned |
| <a name="output_vpc_private_subnets"></a> [vpc\_private\_subnets](#output\_vpc\_private\_subnets) | VPC private subnets |
| <a name="output_vpc_public_subnets"></a> [vpc\_public\_subnets](#output\_vpc\_public\_subnets) | VPC public subnets |
<!-- END_TF_DOCS -->