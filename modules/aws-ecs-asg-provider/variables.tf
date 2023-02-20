
variable "create_asg" {
  description = "Control if ASG should be created"
  type = bool
  default = true
}

variable "cluster_name" {
  description = "ECS cluster name"
  type = string
}

variable "instance_type" {
  description = "EC2 Instance Type for ECS"
  type = string
}

variable "security_groups" {
  description = "List of security group IDs"
  type = list(string)
}

variable "subnet_ids" {
  description = <<EOT
A list of subnet IDs to launch resources in.
Subnets automatically determine which availability zones the group will reside"
EOT
  type = list(string)
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
}

variable "tags" {
  description = "Resource tags"
  type = map(string)
}
