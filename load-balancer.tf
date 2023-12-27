data "aws_subnets" "public_sids" {

   filter {
    name   = "tag:Name"
    values = ["PublicSubnet-1"]
  }
}
locals {
public_subnets_ids = toset(data.aws_subnets.public_sids.ids)

}

resource "aws_lb" "internetfacing-alb" {
  subnets            = local.public_subnets_ids
  name               = "internetfacingAlb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internetfacing-alb-sg.id]
  ip_address_type    = "ipv4"
  tags = {
    Environment = "Internet-Facing-Load-Balancer"
  }
}

# Target using Terrform

resource "aws_lb_target_group" "internetfacing-alb-tg" {
  name        = "internetfacing-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      =  aws_vpc.main-vpc.id
  health_check {
    interval            = 10
    path                = "/"
	matcher             = "200"
	port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Linster using Terraform

resource "aws_lb_listener" "internetfacing-alb-listener" {
  load_balancer_arn = aws_lb.internetfacing-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internetfacing-alb-tg.arn
  }
}

/*

resource "aws_lb" "internal-alb" {
  count              = length(var.availability-zone)
  name               = "internalAlb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal-alb-sg.id]
  subnets            = aws_subnet.private-subnet[count.index].id
  ip_address_type    = "ipv4"


  tags = {
    Environment = "Internal-Load-Balancer"
  }

}

# Target using Terrform

resource "aws_lb_target_group" "internal-alb-tg" {
  health_check {
    interval            = 10
    path                = "/"
	matcher             = "200"
	port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "internal-alb-tg"
  port        = 22
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      =  aws_vpc.main-vpc.id
}


# Linster using Terraform

resource "aws_lb_listener" "internal-alb-listener" {
  count             = length(aws_lb.internal-alb)
  load_balancer_arn =  aws_lb.internal-alb[count.index].arn
  port              = "22"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal-alb-tg.arn
  }
}
*/