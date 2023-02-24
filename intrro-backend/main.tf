
data "aws_caller_identity" "current" { }

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "application_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.application_vpc.id]
  }
}

/* --- ASG provider for ECS --- */

module "ecs_asg_provider" {
  source = "./../modules/aws-ecs-asg-provider"

  cluster_name  = local.ecs_cluster_name
  instance_type = var.asg_instance_type

  min_size          = var.asg_min_size
  max_size          = var.asg_max_size
  desired_capacity  = var.asg_desired_capacity

  security_groups = [aws_security_group.ecs_sg.id]
  subnet_ids      = data.aws_subnets.vpc_subnets.ids

  tags = local.tags
}

/* --- ECS Cluster --- */
module "ecs" {
  source = "./../modules/aws-ecs"

  name = local.ecs_cluster_name
  capacity_providers = [
    module.ecs_asg_provider.ecs_capacity_provider_name
  ]
  default_capacity_provider_strategy = [{
    capacity_provider = module.ecs_asg_provider.ecs_capacity_provider_name
    weight            = "1"
  }]

  tags = local.tags
}
/* --- ASG Security Group --- */

resource "aws_security_group" "ecs_sg" {
  name = "${var.environment}-${var.app_name}-public-sg"
  description = "ECS ASG Security Group"
  vpc_id = data.aws_vpc.application_vpc.id

  tags = local.tags
}

resource "aws_security_group_rule" "public_out" {
  security_group_id = aws_security_group.ecs_sg.id

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}


resource "aws_security_group_rule" "public_in_http" {
  security_group_id = aws_security_group.ecs_sg.id

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_in_https" {
  security_group_id = aws_security_group.ecs_sg.id

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

