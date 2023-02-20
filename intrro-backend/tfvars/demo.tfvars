environment = "production"
app_name = "intrro"
vpc_id = "vpc-e6d74e8e"

#asg_instance_type = "t3.xlarge"
asg_instance_type = "t3.small"
asg_min_size = 1
asg_max_size = 2
asg_desired_capacity = 1

tags = {
  Application: "Intrro-Backend"
}