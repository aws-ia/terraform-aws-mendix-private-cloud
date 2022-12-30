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

resource "kubernetes_namespace" "loki" {
  metadata {
    name = "loki"
  }
}

resource "helm_release" "loki" {
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = "loki"
  values = [
    templatefile("${path.module}/helm-values/loki-stack-values.yaml", {})
  ]
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
        mendix_native  = "${indent(8, templatefile("${path.module}/dashboards/mendix_native.json.tpl", {}))}",
        pvc_disk_space = "${indent(8, templatefile("${path.module}/dashboards/pvc_disk_space.json.tpl", {}))}",
        kubernetes     = "${indent(8, templatefile("${path.module}/dashboards/kubernetes.json.tpl", {}))}",
        rds            = "${indent(8, templatefile("${path.module}/dashboards/rds.json.tpl", {}))}",
        hostname       = var.domain_name
        role_arn       = aws_iam_role.grafana_irsa_role.arn
        admin_password = aws_secretsmanager_secret_version.grafana.secret_string
        aws_region     = var.aws_region
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