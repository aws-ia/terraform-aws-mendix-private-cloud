module "vpc" {
  source = "./modules/vpc"
  region = var.aws_region
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
  identifier                        = "${module.vpc.cluster_name}-database-${each.key}"
  subnets                           = module.vpc.vpc_private_subnets
  cluster_primary_security_group_id = module.eks_blueprints.cluster_primary_security_group_id
  file_storage_endpoint             = module.file_storage.filestorage_regional_endpoint
  filestorage_shared_bucket_arn     = module.file_storage.filestorage_shared_bucket_arn
  filestorage_kms_key_arn           = module.file_storage.filestorage_kms_key_arn
  cluster_name                      = module.vpc.cluster_name
  secrets_manager_name              = "${module.vpc.cluster_name}-${each.key}-secrets"
  aws_caller_identity_account_id    = data.aws_caller_identity.current.account_id
  oidc_provider                     = module.eks_blueprints.oidc_provider
  environment_internal_name         = each.key
}

data "aws_caller_identity" "current" {}

module "container_registry" {
  source                   = "./modules/container-registry"
  registry_repository_name = "${module.vpc.cluster_name}-ecr"
  region                   = var.aws_region
  account_id               = data.aws_caller_identity.current.account_id
  oidc_provider            = module.eks_blueprints.oidc_provider

  depends_on = [module.eks_blueprints]
}

resource "aws_ebs_encryption_by_default" "ebs_encryption" {
  enabled = true
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.18.1"

  node_security_group_additional_rules = {
    cluster_to_nginx_webhook = {
      description                   = "Cluster to ingress-nginx webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
    cluster_to_load_balancer_controller_webhook = {
      description                   = "Cluster to load balancer controller webhook"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  # EKS CLUSTER
  cluster_name       = module.vpc.cluster_name
  cluster_version    = "1.24"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.vpc_private_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.allowed_ips

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    t3_medium = {
      node_group_name = "managed-ondemand"
      instance_types  = [var.eks_node_instance_type]
      subnet_ids      = module.vpc.vpc_private_subnets
      public_ip       = false
      disk_size       = 25
    }
  }
}

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.18.1"

  eks_cluster_id       = module.eks_blueprints.eks_cluster_id
  eks_cluster_endpoint = module.eks_blueprints.eks_cluster_endpoint
  eks_oidc_provider    = module.eks_blueprints.oidc_provider
  eks_cluster_version  = module.eks_blueprints.eks_cluster_version
  eks_cluster_domain   = var.domain_name

  # EKS Managed Add-ons
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true
  enable_amazon_eks_aws_ebs_csi_driver = true

  # Add-ons
  enable_aws_load_balancer_controller = true

  enable_secrets_store_csi_driver              = true
  enable_secrets_store_csi_driver_provider_aws = true
  csi_secrets_store_provider_aws_helm_config = {
    values = [templatefile("${path.module}/helm-values/csi-secrets-store-provider-aws.yaml", {
      hostname = var.domain_name
    })]
  }

  enable_external_dns = true
  external_dns_helm_config = {
    values = [templatefile("${path.module}/helm-values/external-dns-values.yaml", {})]
  }

  enable_ingress_nginx = true
  ingress_nginx_helm_config = {
    values = [templatefile("${path.module}/helm-values/nginx-values.yaml", {
      hostname = var.domain_name
    })]
  }

  enable_cert_manager = true
  cert_manager_helm_config = {
    set_values = [
      {
        name  = "extraArgs[0]"
        value = "--acme-http01-solver-nameservers=8.8.8.8:53\\,1.1.1.1:53"
      }
    ]
  }

  enable_prometheus = true
  prometheus_helm_config = {
    values = [templatefile("${path.module}/helm-values/prometheus-values.yaml", {})]
  }

  depends_on = [module.eks_blueprints, aws_route53_zone.cluster_dns]
}

module "monitoring" {
  source        = "./modules/monitoring"
  aws_region    = var.aws_region
  account_id    = data.aws_caller_identity.current.account_id
  cluster_name  = module.vpc.cluster_name
  oidc_provider = module.eks_blueprints.oidc_provider
  domain_name   = var.domain_name

  depends_on = [module.eks_blueprints_kubernetes_addons]
}

resource "kubernetes_namespace" "mendix" {
  metadata {
    name = "mendix"
  }
}

resource "helm_release" "mendix_installer" {
  name      = "mendixinstaller"
  chart     = "./charts/mendix-installer"
  namespace = "mendix"
  values = [
    templatefile("${path.module}/helm-values/mendix-installer-values.yaml.tpl",
      {
        cluster_name                 = module.vpc.cluster_name,
        account_id                   = data.aws_caller_identity.current.account_id,
        cluster_id                   = var.cluster_id,
        cluster_secret               = sensitive(var.cluster_secret),
        mendix_operator_version      = var.mendix_operator_version,
        aws_region                   = module.vpc.region,
        certificate_expiration_email = var.certificate_expiration_email
        registry_pullurl             = module.container_registry.container_registry_hostname,
        registry_repository          = module.container_registry.container_registry_name,
        registry_iam_role            = module.container_registry.container_irsa_role_arn,
        ingress_domainname           = var.domain_name,
        environments_internal_names  = var.environments_internal_names
    })
  ]

  depends_on = [module.eks_blueprints, module.eks_blueprints_kubernetes_addons]
}