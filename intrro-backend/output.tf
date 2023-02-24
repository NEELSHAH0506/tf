
output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "ecs_cluster_arn" {
  value = module.ecs.ecs_cluster_arn
}
