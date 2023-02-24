
output "ecs_cluster_arn" {
  value = one(aws_ecs_cluster.this[*].arn)
}
