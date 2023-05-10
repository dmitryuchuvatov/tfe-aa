# Creating IAM role

resource "aws_iam_role" "role" {
  name = "tfe-aa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Creating IAM Instance Profile
resource "aws_iam_instance_profile" "profile" {
  name = "tfe-aa-instance"
  role = aws_iam_role.role.name
}

# Creating IAM Role inline policy

resource "aws_iam_role_policy" "policy" {
  name = "tfe-aa-bucket"
  role = aws_iam_role.role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "arn:aws:s3:::tfe-aa-bucket",
          "arn:aws:s3:::tfe-aa-software",
          "arn:aws:s3:::*/*"
        ]
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : "*"
      }
    ]
  })
}