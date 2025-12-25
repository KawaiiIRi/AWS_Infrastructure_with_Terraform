# module "task" {
#   source = "../../modules/ecs/task"
#   service_name = local.service_name
#   env = terraform.workspace
#   # タスク及び実行ロールを/module/ecs/task/iam_roles.tf からARNを取得してくる。
#   task_role_arn = module.roles.task_role_arn
#   task_exec_role_arn = module.roles.task_exec_role_arn
#   container_definition = module.container_definitions
# }