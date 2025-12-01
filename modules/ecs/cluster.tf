# タグをまとめてつくる
locals {
  ecs_cluster_tags = merge(
    var.cluster_additional_tags,
    {
      ServiceName = var.service_name
      Env         = var.env
    }
  )
}
# ECS クラスターを1個作る + そのクラスターにタグをきれいに付ける + FARGATE を使うように設定する
# ECS本体の作成
resource "aws_ecs_cluster" "cluster" {
  name = "${var.service_name}-${var.env}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = local.ecs_cluster_tags
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [
    "FARGATE"
  ]
}
