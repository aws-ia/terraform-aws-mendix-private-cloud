{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "LimitedAttachmentPermissions",
        "Effect": "Allow",
        "Action": [
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy"
        ],
        "Resource": "*",
        "Condition": {
          "ArnEquals": {
            "iam:PolicyArn": [
              "${environment_policy_arn}"
            ]
          }
        }
      },
      {
        "Sid": "ManageRoles",
        "Effect": "Allow",
        "Action": [
          "iam:CreateRole",
          "iam:TagRole",
          "iam:DeleteRole"
        ],
        "Resource": [
          "arn:aws:iam::${aws_account_id}:role/mendix-*"
        ]
      },
      {
        "Sid": "AllowFileCleanup",
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${filestorage_shared_bucket_name}"
        ],
        "Action": [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject",
          "s3:ListBucket"
        ]
      },
      {
        "Sid": "AllowCreateRDSTenants",
        "Effect": "Allow",
        "Action": [
          "rds-db:connect"
        ],
        "Resource": [
%{ for index, db_instance_resource_id in db_instance_resource_ids ~}
  %{ if index != length(db_instance_resource_ids) - 1 ~}
            "arn:aws:rds-db:${aws_region}:${aws_account_id}:dbuser:${db_instance_resource_id}/${db_instance_usernames[index]}",
  %{ else ~}
            "arn:aws:rds-db:${aws_region}:${aws_account_id}:dbuser:${db_instance_resource_id}/${db_instance_usernames[index]}"
  %{ endif ~}
%{ endfor ~}
        ]
      }
    ]
  }