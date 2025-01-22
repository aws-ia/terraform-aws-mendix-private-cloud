locals {
  cluster_name = "${var.eks_cluster_name_prefix}-${random_string.random_eks_suffix.result}"
}

resource "random_string" "random_eks_suffix" {
  length    = 3
  min_lower = 3
  special   = false
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.cluster_name
}

module "vpc" {
  source       = "./modules/vpc"
  region       = var.aws_region
  cluster_name = local.cluster_name
}

resource "aws_route53_zone" "cluster_dns" {
  name          = var.domain_name
  force_destroy = true
}

module "file_storage" {
  source         = "./modules/file-storage"
  s3_bucket_name = var.s3_bucket_name
}

module "databases" {
  for_each = toset(var.environments_internal_names)

  source                            = "./modules/databases"
  identifier                        = "${local.cluster_name}-database-${each.key}"
  subnets                           = module.vpc.vpc_private_subnets
  postgres_version                  = var.postgres_version
  cluster_primary_security_group_id = module.eks_blueprints.cluster_primary_security_group_id
}

resource "aws_iam_policy" "environment_policy" {
  name        = "${local.cluster_name}-env-policy"
  description = "Environment Template Policy"

  policy = templatefile("${path.module}/iam-templates/iam_environment_policy.json.tpl", {
    aws_region                     = var.aws_region
    aws_account_id                 = data.aws_caller_identity.current.account_id
    db_instance_resource_ids       = [for value in values(module.databases) : tostring(value.database_resource_id[0])]
    filestorage_shared_bucket_name = var.s3_bucket_name
  })
}

resource "aws_iam_policy" "provisioner_policy" {
  name        = "${local.cluster_name}-provisioner-policy"
  description = "Storage Provisioner admin Policy"

  policy = templatefile("${path.module}/iam-templates/iam_provisioner_policy.json.tpl", {
    aws_region                     = var.aws_region
    aws_account_id                 = data.aws_caller_identity.current.account_id
    db_instance_resource_ids       = [for value in values(module.databases) : tostring(value.database_resource_id[0])]
    db_instance_usernames          = [for value in values(module.databases) : tostring(value.database_username[0])]
    filestorage_shared_bucket_name = var.s3_bucket_name
    environment_policy_arn         = aws_iam_policy.environment_policy.arn
  })
}

resource "aws_iam_role" "storage_provisioner_role" {
  name        = "${local.cluster_name}-storage-provisioner-irsa"
  description = "Storage Provisioner admin Policy"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks_blueprints.oidc_provider}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${module.eks_blueprints.oidc_provider}:aud" : "sts.amazonaws.com",
            "${module.eks_blueprints.oidc_provider}:sub" : "system:serviceaccount:mendix:mendix-storage-provisioner"
          }
        }
      }
    ]
  })

  managed_policy_arns = [aws_iam_policy.provisioner_policy.arn]
}

data "aws_caller_identity" "current" {}

module "container_registry" {
  source                   = "./modules/container-registry"
  registry_repository_name = "${local.cluster_name}-ecr"
  region                   = var.aws_region
  account_id               = data.aws_caller_identity.current.account_id
  oidc_provider            = module.eks_blueprints.oidc_provider

  depends_on = [module.eks_blueprints]
}

resource "aws_ebs_encryption_by_default" "ebs_encryption" {
  enabled = true
}

module "eks_blueprints" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.21"

  # EKS CLUSTER
  cluster_name    = local.cluster_name
  cluster_version = var.eks_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.vpc_private_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.allowed_ips

  create_node_security_group = false

  # EKS MANAGED NODE GROUPS
  eks_managed_node_groups = {
    t3_medium = {
      min_size     = 3
      max_size     = 3
      desired_size = 3

      attach_cluster_primary_security_group = true
      vpc_security_group_ids                = [module.eks_blueprints.cluster_primary_security_group_id]

      node_group_name = "managed-ondemand"
      instance_types  = [var.eks_node_instance_type]
      subnet_ids      = module.vpc.vpc_private_subnets
      public_ip       = false
      disk_size       = 25
    }
  }
}

module "eks_blueprints_kubernetes_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.8.0"

  cluster_name      = module.eks_blueprints.cluster_name
  cluster_endpoint  = module.eks_blueprints.cluster_endpoint
  oidc_provider_arn = module.eks_blueprints.oidc_provider_arn
  cluster_version   = module.eks_blueprints.cluster_version

  # EKS Managed Add-ons
  eks_addons = {
    coredns    = {}
    kube-proxy = {}
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  # Add-ons
  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    chart_version = "1.6.1"
    set = [{
      name  = "enableServiceMutatorWebhook"
      value = "false"
    }]
  }

  enable_external_dns = true
  external_dns_route53_zone_arns = [
    aws_route53_zone.cluster_dns.arn
  ]
  external_dns = {
    values = [templatefile("${path.module}/helm-values/external-dns-values.yaml", {
      hostname = var.domain_name
    })]
  }

  enable_ingress_nginx = true
  ingress_nginx = {
    values = [templatefile("${path.module}/helm-values/nginx-values.yaml", {
      hostname = var.domain_name
    })]
  }

  enable_cert_manager = true
  cert_manager = {
    set_values = [
      {
        name  = "extraArgs[0]"
        value = "--acme-http01-solver-nameservers=8.8.8.8:53\\,1.1.1.1:53"
      }
    ]
  }

  enable_aws_for_fluentbit = true
  aws_for_fluentbit_cw_log_group = {
    name = aws_cloudwatch_log_group.aws_for_fluentbit.name
  }

  depends_on = [module.eks_blueprints, aws_route53_zone.cluster_dns]
}

resource "aws_cloudwatch_log_group" "aws_for_fluentbit" {
  name = "/aws/eks/${module.eks_blueprints.cluster_name}/aws-fluentbit-logs"

  retention_in_days = 30
}

module "monitoring" {
  source        = "./modules/monitoring"
  aws_region    = var.aws_region
  account_id    = data.aws_caller_identity.current.account_id
  cluster_name  = local.cluster_name
  oidc_provider = module.eks_blueprints.oidc_provider
  domain_name   = var.domain_name

  cloudwatch_log_group_arn  = aws_cloudwatch_log_group.aws_for_fluentbit.arn
  cloudwatch_log_group_name = aws_cloudwatch_log_group.aws_for_fluentbit.name

  depends_on = [module.eks_blueprints_kubernetes_addons, aws_eks_addon.adot_addon]
}

resource "kubernetes_namespace" "mendix" {
  metadata {
    name = "mendix"
  }
}

resource "helm_release" "mendix_installer" {
  name      = "mendixinstaller"
  chart     = "${path.module}/charts/mendix-installer"
  namespace = "mendix"
  values = [
    templatefile("${path.module}/helm-values/mendix-installer-values.yaml.tpl",
      {
        cluster_name                       = local.cluster_name,
        account_id                         = data.aws_caller_identity.current.account_id,
        namespace_id                       = var.namespace_id,
        namespace_secret                   = sensitive(var.namespace_secret),
        mendix_operator_version            = var.mendix_operator_version,
        aws_region                         = module.vpc.region,
        certificate_expiration_email       = var.certificate_expiration_email
        s3_bucket_name                     = var.s3_bucket_name
        environment_iam_template_policy    = aws_iam_policy.environment_policy.arn
        storage_provisioner_iam_admin_role = aws_iam_role.storage_provisioner_role.arn
        oidc_url                           = "https://${module.eks_blueprints.oidc_provider}"
        database_server_addresses          = [for value in values(module.databases) : tostring(value.database_server_address[0])]
        database_ports                     = [for value in values(module.databases) : tostring(value.database_port[0])]
        database_usernames                 = [for value in values(module.databases) : tostring(value.database_username[0])]
        database_names                     = [for value in values(module.databases) : tostring(value.database_name[0])]
        database_passwords                 = [for value in values(module.databases) : tostring(value.database_password[0])]
        registry_pullurl                   = module.container_registry.container_registry_hostname,
        registry_repository                = module.container_registry.container_registry_name,
        registry_iam_role                  = module.container_registry.container_irsa_role_arn,
        ingress_domainname                 = var.domain_name,
        environments_internal_names        = var.environments_internal_names
    })
  ]

  depends_on = [module.eks_blueprints, module.eks_blueprints_kubernetes_addons]
}

resource "aws_eks_addon" "adot_addon" {
  cluster_name  = module.eks_blueprints.cluster_name
  addon_name    = "adot"
  addon_version = "v0.94.1-eksbuild.1"

  depends_on = [module.eks_blueprints, module.eks_blueprints_kubernetes_addons]
}

module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.39"

  role_name_prefix = "${module.eks_blueprints.cluster_name}-ebs-csi-driver-"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks_blueprints.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}
