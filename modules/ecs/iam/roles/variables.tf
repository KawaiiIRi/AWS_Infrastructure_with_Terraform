variable "service_name" {
  description = "サービス名"
  type        = string
}

variable "env" {
  description = "環境識別子(dev, stg, prod)"
  type        = string
}

variable "task_role_additional_tags" {
  description = "タスクロールに付与する追加タグ"
  type        = map(string)
  default     = {}
}

variable "task_exec_role_additional_tags" {
  description = "タスク実行ロールに付与する追加タグ"
  type        = map(string)
  default     = {}
}

# IAMロールに紐づけるポリシーの定義
variable "task_role_managed_policy_arns" {
  description = "タスクロールに付与する管理ポリシーARNのリストに指定します。"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.task_role_managed_policy_arns) < 10
    error_message = "Number of managed policies attached must be at most 10."
  }
}

variable "task_exec_role_managed_policy_arns" {
  description = "タスク実行ロールに付与する管理ポリシーARNのリスト"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

# インラインポリシー
variable "task_role_inline_policies" {
  description = <<DESC
  タスクロール自体に付与するインラインポリシーです。キーにインラインポリシー名、値にインラインポリシーのボディ(JSON)を記述する。
  DESC
  type        = map(string)
  default     = {}
}