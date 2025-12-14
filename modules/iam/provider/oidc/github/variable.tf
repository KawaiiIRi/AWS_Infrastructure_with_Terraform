variable "service_name" {
  description = "IAM role service name"
  type        = string
}

variable "env" {
  description = "Environment (dev, stg, prod)"
  type        = string
}

variable "iam_role_additional_tags" {
  description = "Additional tags for IAM role"
  type        = map(string)
  default     = {}

  validation {
    condition     = length(setintersection(keys(var.iam_role_additional_tags), ["Env", "ServiceName"])) == 0
    error_message = "Key names Env and ServiceName are reserved."
  }
}

variable "github_organization_name" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repository_name" {
  description = "GitHub repository name"
  type        = string
}

variable "managed_iam_policy_arns" {
  description = "Managed IAM policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policy_documents" {
  description = "Inline policy documents (map: name => JSON string)"
  type        = map(string)
  default     = {}
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs for push/pull permissions"
  type        = list(string)
  default     = []
}
