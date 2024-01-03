grafana.ini:
  auth:
    sigv4_auth_enabled: true
  server:
    domain: monitoring.${hostname}
    root_url: "%(protocol)s://%(domain)s/grafana"
    serve_from_sub_path: true
persistence:
  type: pvc
  enabled: true
  size: 1Gi
serviceAccount:
  create: true
  name: grafana
  namespace: grafana
  annotations:
    eks.amazonaws.com/role-arn: ${role_arn}
adminUser: admin
adminPassword: ${admin_password}
ingress:
  enabled: true
  annotations: 
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - "monitoring.${hostname}"
  path: "/"
  tls:
  - hosts:
    - monitoring.${hostname}
    secretName: monitoring.${hostname}
datasources:
 datasources.yaml:
   apiVersion: 1
   datasources:
   - name: Prometheus
     type: prometheus
     jsonData:
       sigV4Auth: true
       sigV4Region: ${aws_region}
       sigV4AuthType: default
     type: prometheus
     isDefault: true
     url: ${prometheus_endpoint}
   - name: CloudWatch
     type: cloudwatch
     access: proxy
     uid: cloudwatch
     editable: false
     jsonData:
      authType: default
      defaultRegion: ${aws_region}
dashboardProviders:
 dashboardproviders.yaml:
   apiVersion: 1
   providers:
   - name: 'default'
     orgId: 1
     folder: ''
     type: file
     disableDeletion: false
     editable: true
     options:
       path: /var/lib/grafana/dashboards/default
dashboards:
  default:
    mendix_native:
      json: |
        ${mendix_native}
    pvc_disk_space:
      json: |
        ${pvc_disk_space}
    kubernetes:
      json: |
        ${kubernetes}
    rds:
      json: |
        ${rds}

