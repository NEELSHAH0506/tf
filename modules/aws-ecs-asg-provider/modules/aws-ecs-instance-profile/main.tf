
resource "aws_iam_role" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = local.iam_role_name
  path = "/ecs/"

  tags = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.name}_ecs_instance_profile"
  role = local.iam_role_name

  depends_on = [aws_iam_role.this]
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  count = var.create_instance_profile ? 1 : 0

  role       = one(aws_iam_role.this[*].id)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core" {
  count = var.include_ssm && var.create_instance_profile ? 1 : 0

  role       = one(aws_iam_role.this[*].id)
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  count = var.create_instance_profile ? 1 : 0

  role       = one(aws_iam_role.this[*].id)
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
