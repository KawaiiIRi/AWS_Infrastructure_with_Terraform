# 呼び出し元のリソースをここで定義

module "vpc" {
  source         = "./modules/vpc"
  service_name   = "sample"
  env            = terraform.workspace
  vpc_cidr_block = "10.0.0.0/16"
  vpc_additional_tags = {
    Usage = "sample vpc explanation"
  }

  subnet_cidrs = {
    public  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
    private = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
  }
}

module "ecs_cluster" {
  source       = "./modules/ecs"
  service_name = "sample"
  env          = terraform.workspace
}

module "ecr" {
  source                      = "./modules/ecr"
  service_name                = "sample"
  env                         = terraform.workspace
  role                        = "api"
  image_tag_mutability        = "IMMUTABLE" # 必要に応じて MUTABLE に変更
  repository_lifecycle_policy = ""          # カスタム JSON を渡す場合はここに文字列で指定
}

module "iam_oidc_provider" {
  source                   = "./modules/iam/provider/oidc/github"
  service_name             = "sample"
  env                      = terraform.workspace
  github_organization_name = "your-org"
  github_repository_name   = "your-repo"
  managed_iam_policy_arns  = [] # 必要に応じて AWS 管理ポリシー ARN を列挙
  inline_policy_documents  = {} # 必要に応じて map でポリシー JSON を渡す
}
