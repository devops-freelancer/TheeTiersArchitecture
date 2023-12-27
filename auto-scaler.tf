resource "aws_launch_configuration" "app-scaler" {
  name_prefix                 = "app-scaler"
  image_id                    = var.ami-id
  instance_type               = var.instance-type
  key_name                    = "freelancer"
  associate_public_ip_address = false
  security_groups             = [aws_security_group.internetfacing-alb-sg.id]
  lifecycle {
             create_before_destroy = true
            }
 }

data "aws_subnets" "private_sids" {

   filter {
    name   = "vpc-id"
    values = [aws_vpc.main-vpc.id]
  }
  
   tags = {
    Tier = "Private"
  }
}

/* locals {
private_subnets_ids = toset(data.aws_subnets.private_sids.ids)

}
*/

 # Create Auto Scaling Group #

resource "aws_autoscaling_group" "app_scale_group" {
  launch_configuration = aws_launch_configuration.app-scaler.id
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
  target_group_arns    = [aws_lb_target_group.internetfacing-alb-tg.arn]
   vpc_zone_identifier = [element(data.aws_subnets.private_sids.ids, 0), element(data.aws_subnets.private_sids.ids, 2)]
   count = length([element(data.aws_subnets.private_sids.ids, 0), element(data.aws_subnets.private_sids.ids, 2)])
  tag {
    key                 = "Name"
    value               =  "AppServer-${count.index + 1}"
    propagate_at_launch = true
  }
}


