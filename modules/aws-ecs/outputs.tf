
output "ecs_cluster_arn" {
  value = one(aws_ecs_cluster.this[*].arn)
}

output "ecs_cluster_name" {
  value = one(aws_ecs_cluster.this[*].name)
}

output "ecs_cluster_id" {
  value = one(aws_ecs_cluster.this[*].id)
}
