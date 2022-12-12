#S3 user will be replaced by IRSA
#tfsec:ignore:*
resource "aws_iam_user_policy" "s3_ro" {
  name = "s3_bucket_role"
  user = aws_iam_user.s3.name

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject"
        ],
        Resource : [
          aws_s3_bucket.apps_shared_bucket.arn
        ]
      },
      {
        Effect : "Allow",
        Action : [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject"
        ],
        Resource : [
          "${aws_s3_bucket.apps_shared_bucket.arn}/*"
        ]
      },
      {
        "Action" : [
          "kms:GenerateDataKey"
        ],
        "Effect" : "Allow",
        "Resource" : [
          aws_kms_key.cmk_shared_bucket.arn
        ]
      }
    ]
  })
}

#tfsec:ignore:*
resource "aws_iam_user" "s3" {
  name = var.s3_user_name
  path = "/system/"
}

resource "aws_iam_access_key" "s3" {
  user = aws_iam_user.s3.name
}