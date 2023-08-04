{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowListingOfUserFolder",
        "Action": [
          "s3:ListBucket"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${filestorage_shared_bucket_name}"
        ],
        "Condition": {
          "StringLike": {
            "s3:prefix": [
              "$${aws:PrincipalTag/privatecloud.mendix.com/s3-prefix}/*",
              "$${aws:PrincipalTag/privatecloud.mendix.com/s3-prefix}"
            ]
          }
        }
      },
      {
        "Sid": "AllowAllS3ActionsInUserFolder",
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${filestorage_shared_bucket_name}/$${aws:PrincipalTag/privatecloud.mendix.com/s3-prefix}/*"
        ],
        "Action": [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject"
        ]
      },
      {
        "Sid": "AllowConnectionToDatabase",
        "Effect": "Allow",
        "Action": "rds-db:connect",
        "Resource": [
%{ for index, db_instance_resource_id in db_instance_resource_ids ~}
  %{ if index != length(db_instance_resource_ids) - 1 ~}
            "arn:aws:rds-db:${aws_region}:${aws_account_id}:dbuser:${db_instance_resource_id}/$${aws:PrincipalTag/privatecloud.mendix.com/database-user}",
  %{ else ~}
            "arn:aws:rds-db:${aws_region}:${aws_account_id}:dbuser:${db_instance_resource_id}/$${aws:PrincipalTag/privatecloud.mendix.com/database-user}"
  %{ endif ~}
%{ endfor ~}
        ]
      }
    ]
  }