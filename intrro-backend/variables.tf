
variable "environment" {
  description = "Application environment name"
  type = string
}

variable "app_name" {
  description = "Application Name"
  type = string
}

variable "tags" {
  description = "Resource tags"
  type = map(string)
}

variable "vpc_id" {
  description = "Application VPC id"
  type = string
}

variable "asg_instance_type" {
  description = "EC2 Instance type for asg"
  type = string
}

variable "asg_min_size" {
  description = "The minimum size of the autoscaling group"
  type = number
}

variable "asg_max_size" {
  description = "The maximum size of the autoscaling group"
  type = number
}

variable "asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type = number
}

locals {
  tags = merge(var.tags, {
    Terraform = "true"
  })
  ecs_cluster_name = "${var.environment}-${var.app_name}-cluster"
}
