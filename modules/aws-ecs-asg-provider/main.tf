
data "aws_ami" "amazon_ecs_hvm" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "ec2_ecs_instance_profile" {
  source = "./modules/aws-ecs-instance-profile"
  create_instance_profile = var.create_asg

  include_ssm = false
  name = var.cluster_name
  tags = var.tags
}


/* ASG for ECS */
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  create_asg = var.create_asg

  name = "${var.cluster_name}_asg"

  # Launch configuration
  lc_name   = "${var.cluster_name}_lc"
  use_lc    = true
  create_lc = var.create_asg
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  image_id                 = data.aws_ami.amazon_ecs_hvm.id
  instance_type            = var.instance_type
  security_groups          = var.security_groups
  iam_instance_profile_arn = module.ec2_ecs_instance_profile.iam_instance_profile_arn
  user_data                = data.template_file.user_data.rendered

  # Auto scaling group
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = 0

  tags_as_map = var.tags
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    cluster_name = var.cluster_name
  }
}

resource "aws_ecs_capacity_provider" "asg" {
  count = var.create_asg ? 1 : 0
  name = "${var.cluster_name}_asg"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.autoscaling_group_arn
  }
}
