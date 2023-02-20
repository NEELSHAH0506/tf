
output "iam_instance_profile_id" {
  description = "ID of the IAM instance profile"
  value       = one(aws_iam_instance_profile.this[*].id)
}

output "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = one(aws_iam_instance_profile.this[*].arn)
}

output "iam_role_id" {
  description = "ID of the IAM role"
  value       = one(aws_iam_role.this[*].id)
}
