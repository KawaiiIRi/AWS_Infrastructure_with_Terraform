provider "aws" {
  region = "ap-northeast-1"
  # 必要に応じて profile などを指定
  # profile = "your-profile-name"
}

terraform {
  required_version = "~> 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13.0"
    }
  }
  backend "s3" {
    # stateファイルの保存先を任意のS3とする。
    # bucket       = "terraform-state-S3"
    bucket       = "terraform-state-sample-bucket-20251123"
    key          = "090-vpc/vpc.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
