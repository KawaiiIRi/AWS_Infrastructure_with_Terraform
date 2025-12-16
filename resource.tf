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

module "ecr_api" {
  source                      = "./modules/ecr"
  service_name                = "sample"
  env                         = terraform.workspace
  role                        = "api"
  image_tag_mutability        = "IMMUTABLE" # 必要に応じて MUTABLE に変更
  repository_lifecycle_policy = ""          # カスタム JSON を渡す場合はここに文字列で指定
}
module "ecr_web" {
  source                      = "./modules/ecr"
  service_name                = "sample"
  env                         = terraform.workspace
  role                        = "web"
  image_tag_mutability        = "IMMUTABLE"
  repository_lifecycle_policy = ""
}

module "iam_oidc_provider" {
  source                   = "./modules/iam/provider/oidc/github"
  service_name             = "sample"
  env                      = terraform.workspace
  # # Githubアカウントユーザー名
  # github_organization_name = "your-org"
  # Github上のpush対象リポジトリ
  # github_repository_name   = "your-repo"
  github_organization_name = "KawaiiIRi"
  github_repository_name   = "AWS_Infrastructure_with_Terraform"
  managed_iam_policy_arns  = [] # 必要に応じて AWS 管理ポリシー ARN を列挙
  inline_policy_documents  = {} # 必要に応じて map でポリシー JSON を渡す
  #ecr_repository_arns = ["arn:aws:ecr:ap-northeast-1:<アカウントID>:repository/sample-dev-api"]
  ecr_repository_arns = [
    "arn:aws:ecr:ap-northeast-1:<アカウントID>:repository/sample-dev-api",
    "arn:aws:ecr:ap-northeast-1:<アカウントID>:repository/sample-dev-web"
  ]
}
