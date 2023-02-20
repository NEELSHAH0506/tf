
output "ecs_capacity_provider_name" {
  value = one(aws_ecs_capacity_provider.asg[*].name)
}
