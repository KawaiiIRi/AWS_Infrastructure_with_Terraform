locals {
  task_role_name      = "${var.service_name}-${var.env}-task-role"
  task_exec_role_name = "${var.service_name}-${var.env}-task-exec-role"

  # 共通タグ定義
  base_tags = {
    ServiceName = var.service_name
    Env         = var.env
  }

  # 共通タグと追加タグをまとめる
  task_role_tags      = merge(local.base_tags, var.task_role_additional_tags)
  task_exec_role_tags = merge(local.base_tags, var.task_exec_role_additional_tags)
}

# タスクロール
resource "aws_iam_role" "task_role" {
  name               = local.task_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_document.json
  tags               = local.task_role_tags
}

# タスクロール管理ポリシーARNの紐づけ部分(作成済みのIAMロールとAWSまたはカスタマー管理ポリs－を紐づけるためのリソース)
resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  for_each   = toset(var.task_role_managed_policy_arns)
  role       = aws_iam_role.task_role.name
  policy_arn = each.key
}

resource "aws_iam_role_policy_attachment" "task_exec_role_policy_attachment" {
  for_each   = toset(var.task_exec_role_managed_policy_arns)
  role       = aws_iam_role.task_exec_role.name
  policy_arn = each.key
}

# タスクロールのインラインポリシー
resource "aws_iam_role_policy" "task_role_inline_policies" {
  for_each = var.task_role_inline_policies
  name     = each.key
  role     = aws_iam_role.task_role.name
  policy   = each.value
}