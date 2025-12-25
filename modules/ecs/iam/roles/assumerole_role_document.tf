# タスクロールの作成。(信頼関係)
# ECSがIAMロールを引き受けられる側
data "aws_iam_policy_document" "assume_role_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}