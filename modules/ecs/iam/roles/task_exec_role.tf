# タスク実行ロールの構成
# ここのタスク実行ロールはコンテナイメージのECRからのPullと、コンテナの標準出力に出力された内容のCloudwatch Logsへの書き込みを担うものとする。
resource "aws_iam_role" "task_exec_role" {
  name               = local.task_exec_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_document.json
  tags               = local.task_exec_role_tags
}

# タスク実行ロールに紐づけるIAMポリシ－ドキュメント
data "aws_iam_policy_document" "task_exec_role_policy_document" {
  version = "2012-10-17"
  statement {
    sid = "ECRPullImage"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "CloudWatchPutLog"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

# IAMポリシードキュメントとタスク実行ロールの紐づけ
resource "aws_iam_role_policy" "task_exec_role_policy" {
  role   = aws_iam_role.task_exec_role.name
  policy = data.aws_iam_policy_document.task_exec_role_policy_document.json
}
