grafana.ini:
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
    - "monitoringg.${hostname}"
  path: "/"
  tls:
  - hosts:
    - monitoringg.${hostname}
    secretName: monitoringg.${hostname}
datasources:
 datasources.yaml:
   apiVersion: 1
   datasources:
   - name: Prometheus
     type: prometheus
     url: http://prometheus-server.prometheus.svc.cluster.local
     access: proxy
     isDefault: true
   - name: Loki
     type: loki
     url: http://loki-stack.loki.svc.cluster.local:3100
     access: proxy
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

