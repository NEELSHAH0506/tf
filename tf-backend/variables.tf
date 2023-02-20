
variable "aws_region" {
  description = "AWS region"
  type = string
}

variable "backend_name" {
  description = "Name of backend, used to name resources (s3 and dynamodb)"
  type = string
}

variable "tags" {
  description = "Resource tags"
  type = map(string)
}

locals {
  tags = merge(var.tags, {
    Terraform = "true"
  })
}
