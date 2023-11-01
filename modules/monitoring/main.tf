resource "random_password" "grafana" {
  length  = 15
  special = false
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "grafana" {
  name_prefix             = "grafana-admin-password"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "grafana" {
  secret_id     = aws_secretsmanager_secret.grafana.id
  secret_string = random_password.grafana.result
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "grafana"
  create_namespace = true
  description      = "Grafana Helm Chart deployment configuration"
  values = [
    templatefile(
      "${path.module}/helm-values/grafana-values.yaml.tpl",
      {
        mendix_native = indent(8,
          templatefile("${path.module}/dashboards/mendix_native.json.tpl", {
            awsAccountId    = var.account_id
            awsLogGroupARN  = var.cloudwatch_log_group_arn
            awsLogGroupName = var.cloudwatch_log_group_name
          })
        ),
        pvc_disk_space = indent(8, templatefile("${path.module}/dashboards/pvc_disk_space.json.tpl", {})),
        kubernetes     = indent(8, templatefile("${path.module}/dashboards/kubernetes.json.tpl", {})),
        rds            = indent(8, templatefile("${path.module}/dashboards/rds.json.tpl", {})),
        hostname       = var.domain_name
        role_arn       = aws_iam_role.grafana_irsa_role.arn
        admin_password = aws_secretsmanager_secret_version.grafana.secret_string
        aws_region     = var.aws_region

        prometheus_endpoint = aws_prometheus_workspace.prometheus_workspace.prometheus_endpoint
      }
  )]
}

resource "aws_iam_role_policy" "grafana_irsa_policy" {
  name = "${var.cluster_name}-grafana"
  role = aws_iam_role.grafana_irsa_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetInsightRuleReport",
          "cloudwatch:DescribeAlarmsForMetric",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DescribeAlarmHistory"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowReadingMetricsFromCloudWatch"
      },
      {
        "Action" : [
          "logs:StopQuery",
          "logs:StartQuery",
          "logs:GetQueryResults",
          "logs:GetLogGroupFields",
          "logs:GetLogEvents",
          "logs:DescribeLogGroups"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:*:log-stream:*",
        "Sid" : "AllowReadingLogsFromCloudWatch"
      },
      {
        "Action" : [
          "aps:GetSeries",
          "aps:GetLabels",
          "aps:GetMetricMetadata",
          "aps:QueryMetrics"
        ],
        "Effect" : "Allow",
        "Resource" : aws_prometheus_workspace.prometheus_workspace.arn,
        "Sid" : "AllowReadingPrometheusMetrics"
      },
      {
        "Action" : [
          "ec2:DescribeTags",
          "ec2:DescribeRegions",
          "ec2:DescribeInstances"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowReadingTagsInstancesRegionsFromEC2"
      },
      {
        "Action" : "tag:GetResources",
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowReadingResourcesForTags"
      }
    ]
  })
}

resource "aws_iam_role" "grafana_irsa_role" {
  name = "${var.cluster_name}-grafana-irsa"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc_provider}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${var.oidc_provider}:aud" : "sts.amazonaws.com",
            "${var.oidc_provider}:sub" : "system:serviceaccount:grafana:grafana"
          }
        }
      }
    ]
  })
}

resource "kubernetes_cluster_role" "otel_role" {
  metadata {
    name = "otel-prometheus-role"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "otel_role_binding" {
  metadata {
    name = "otel-prometheus-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "otel-prometheus-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "adot-collector"
    namespace = "mendix"
  }

  depends_on = [kubernetes_cluster_role.otel_role]
}

resource "helm_release" "adot-crd" {
  name      = "adot-crd"
  chart     = "${path.module}/charts/adot-crd"
  namespace = "mendix"
  values = [
    templatefile("${path.module}/helm-values/adot-crd-values.yaml.tpl",
      {
        cluster_name        = var.cluster_name
        aws_region          = var.aws_region
        prometheus_endpoint = aws_prometheus_workspace.prometheus_workspace.prometheus_endpoint
    })
  ]

  depends_on = [kubernetes_cluster_role_binding.otel_role_binding]
}

resource "kubernetes_service_account" "adot_collector_sa" {
  metadata {
    name      = "adot-collector"
    namespace = "mendix"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.adot_collector_irsa.iam_role_arn
    }
  }
}

module "adot_collector_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.20"

  role_name_prefix = "${var.cluster_name}-adot-collector"

  role_policy_arns = {
    prometheus  = "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess",
    xray        = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess",
    cloud_watch = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }

  oidc_providers = {
    main = {
      provider_arn               = "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc_provider}"
      namespace_service_accounts = ["mendix:adot-collector"]
    }
  }
}

resource "aws_prometheus_workspace" "prometheus_workspace" {
  alias = "mendix"
}