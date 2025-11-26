variable "vpc_cidr_block" {
  description = "VPCに割り当てるCIDRブロックを記述します。"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition = can(regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}",
    var.vpc_cidr_block))
    error_message = "Specify VPC CIDR block with the CIDR format."
  }
}

variable "service_name" {
  type        = string
  description = "VPCを利用するサービス名"
}

variable "env" {
  type        = string
  description = "環境識別子(dev,stg,prod)"
}

variable "vpc_additional_tags" {
  description = "VPCに付与したい追加タグ"
  type        = map(string)
  default     = {}

  validation {
    condition = length(setintersection(keys(var.vpc_additional_tags),
    ["Name", "Env"])) == 0
    error_message = "Key names, Name and Env is reserved. Not allowed to use them."
  }
}

# Subnet
variable "subnet_cidrs" {
  description = "サブネットごとのCIDR指定"
  type = object({
    public  = list(string)
    private = list(string)
  })
  # IPアドレス検索
  validation {
    condition = length(setintersection([
      for cidr in var.subnet_cidrs.public : (can(
        regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", cidr)
      ) ? cidr : null)
      ],
    var.subnet_cidrs.public)) == length(var.subnet_cidrs.public)
    error_message = "Specify VPC public Subnet CIDR block with the CIDR format."
  }
  validation {
    condition = length(setintersection([
      for cidr in var.subnet_cidrs.private : (can(
        regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", cidr)
      ) ? cidr : null)
      ],
    var.subnet_cidrs.private)) == length(var.subnet_cidrs.private)
    error_message = "Specify VPC Private Subnet CIDR block with the CIDR format."
  }
  # subnetの冗長数条件定義（個数範囲指定∩個数の一致で定義）
  validation {
    condition     = length(var.subnet_cidrs.public) >= 2
    error_message = "For availability. set more than or equal to 2 public subnet cidrs."
  }
  validation {
    condition     = length(var.subnet_cidrs.private) >= 2
    error_message = "For availability. set more than or equal to 2 private subnet cidrs."
  }
  validation {
    condition     = length(var.subnet_cidrs.public) == length(var.subnet_cidrs.private)
    error_message = "Redundancy of public subnet and private subnet must be same."
  }
}
# ここのコードの意味わからん
variable "subnet_additional_tags" {
  description = "サブネットに付与したい追加タグ(Name, Env, Availability zone, Scope除く))"
  type        = map(string)
  default     = {}
  validation {
    condition = length(setintersection(keys(var.subnet_additional_tags),
    ["Name", "Env", "AvailabilityZone", "Scope"])) == 0
    error_message = "Key names, Name and Env, AvailabilityZone, Scope are reserved. Not allowed to use them."
  }
}

# IGW関連
variable "igw_additional_tags" {
  description = "インターネットゲートウェイに付与したい追加タグ(Name, Env, VpcId除く))"
  type        = map(string)
  default     = {}
  validation {
    condition = length(setintersection(keys(var.igw_additional_tags),
    ["Name", "Env", "VpcId"])) == 0
    error_message = "Key names, Name and Env, VpcId are reserved. Not allowed to use them."
  }
}