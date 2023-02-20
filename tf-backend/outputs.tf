
output "s3_bucket" {
  value = aws_s3_bucket.state_bucket.bucket
}

output "dynamodb_table" {
  value = aws_dynamodb_table.state_lock.name
}

output "kms_key_id" {
  value = aws_kms_alias.key_alias.name
}
