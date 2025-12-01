# Outputs of VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_name" {
  value = module.vpc.vpc_name
}

# ECS OutPuts
output "ecs_cluster_name" {
  value = module.ecs_cluster.ecs_cluster_name
}

output "ecs_cluster_arn" {
  value = module.ecs_cluster.ecs_cluster_arn
}