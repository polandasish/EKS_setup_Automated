resource "aws_iam_role" "eksrole" {
  name = "eks_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com","eks.amazonaws.com"]
        }
      },
    ]
  })

  tags = {
    Name = "Eks-role"
  }
}
resource "aws_iam_policy" "ekspolicy" {
  name        = "eks_policy"
  path        = "/"
  description = "My eks policy"
  
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "eks:*",
          "s3:*",
          "elasticloadbalancong:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_role_policy-attach" {
  role       = aws_iam_role.eksrole.name
  policy_arn = aws_iam_policy.ekspolicy.arn
}

resource "aws_iam_instance_profile" "eks_profile" {
  name = "eks_profile"
  role = aws_iam_role.eksrole.name
}