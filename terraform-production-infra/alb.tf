# ALB
resource "aws_lb" "alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.pb_sbnt_1.id,
    aws_subnet.pb_sbnt_2.id
  ]

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "Web-ALB"
  }
}

# Target Group
resource "aws_lb_target_group" "web_tg" {
  name        = "web-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
  enabled             = true
  path                = "/"
  protocol            = "HTTP"
  port                = "traffic-port"
  matcher             = "200"
  healthy_threshold   = 2
  unhealthy_threshold = 2
  interval            = 30
  timeout             = 5
}

  tags = {
    Name = "Web-TG"
  }
}

# Listner
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
