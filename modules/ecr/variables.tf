variable "service_name" {
  description = "サービス名"
  type        = string
}

variable "env" {
  description = "環境識別子(dev, stg, prod)"
  type        = string
}

variable "role" {
  description = "リポジトリに格納するイメージの役割名（例: api）"
  type        = string
}

# コンテナイメージのイミュータビリティを変数で決定
variable "image_tag_mutability" {
  description = <<DESC
タグの不変設定:
- `MUTABLE`    タグを後から上書き可能
- `IMMUTABLE`  タグを後から上書き不可
DESC
  type        = string
  default     = "MUTABLE"
  # image_tag_mutabilityに許容値バリデーションを定義して誤植での処理通過を防止する。
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "repository_lifecycle_policy" {
  description = "リポジトリのライフサイクルポリシー(JSON文字列)。空ならデフォルトファイルを使用。"
  type        = string
  default     = ""
}
