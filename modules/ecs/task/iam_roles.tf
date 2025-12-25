# # ECSタスクロール、タスク実行ロールの作成モジュール
# # ここで作成したタスクロール及びタスク実行ロールのARNを取得して/module/ecs/task/task.tf のモジュールへ値を渡す
# module "roles" {
#   source = "../../module/ecs/iam/roles"
#   service_name = local.service_name
#   env = terraform.workspace
# }