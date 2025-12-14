resource "aws_iam_role_policy_attachment" "attachments" {
  for_each   = toset(var.managed_iam_policy_arns)
  role       = aws_iam_role.role.id
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = var.inline_policy_documents
  role     = aws_iam_role.role.id
  name     = each.key
  policy   = each.value
}

# ECR への push/pull 用ポリシー（対象リポジトリを ecr_repository_arns に指定）
resource "aws_iam_role_policy" "ecr_push" {
  count = length(var.ecr_repository_arns) > 0 ? 1 : 0

  role = aws_iam_role.role.id
  name = "${var.service_name}-${var.env}-ecr-push"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:ListImages"
        ],
        Resource = var.ecr_repository_arns
      }
    ]
  })
}

