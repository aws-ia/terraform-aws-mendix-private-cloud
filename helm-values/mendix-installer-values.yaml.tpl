clusterID: "${cluster_id}"
clusterSecret: "${cluster_secret}"
mendixOperatorVersion: "${mendix_operator_version}"
awsRegion: "${aws_region}"
certificateExpirationEmail: "${certificate_expiration_email}"
registry:
      pullUrl: "${registry_pullurl}"
      repositoryName: "${registry_repository}"
      iamRole: "${registry_iam_role}"
ingress:
    className: "nginx"
    domainName: "${ingress_domainname}"
environmentsInternalNames:
%{ for name in environments_internal_names ~}
    - ${name}
%{ endfor ~}
clusterName: "${cluster_name}"
accountID: "${account_id}"