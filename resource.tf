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

# 下記、開発環境ごとに異なる値はマスクしています。
module "iam_oidc_provider" {
  source       = "./modules/iam/provider/oidc/github"
  service_name = "sample"
  env          = terraform.workspace
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
    "arn:aws:ecr:ap-northeast-1:637423273193:repository/sample-dev-api",
    "arn:aws:ecr:ap-northeast-1:637423273193:repository/sample-dev-web"
  ]
}

# ECS タスク用 IAM ロール
module "ecs_task_roles" {
  source       = "./modules/ecs/iam/roles"
  service_name = "sample"
  env          = terraform.workspace
}

# CloudWatch Logs グループ
module "ecs_log_group" {
  source                    = "./modules/cloudwatch/logs"
  service_name              = "sample"
  env                       = terraform.workspace
  service_suffix            = "ecs"
  log_retention_in_days     = 30
  log_group_additional_tags = {}
}

# ECS タスク定義
module "ecs_task_definition" {
  source             = "./modules/ecs/task"
  service_name       = "sample"
  env                = terraform.workspace
  task_role_arn      = module.ecs_task_roles.task_role_arn
  task_exec_role_arn = module.ecs_task_roles.task_exec_role_arn

  container_definition = jsonencode([
    {
      name      = "nginx"
      image     = "public.ecr.aws/nginx/nginx:1.21"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = module.ecs_log_group.log_group_name
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "nginx"
        }
      }
    }
  ])
}
