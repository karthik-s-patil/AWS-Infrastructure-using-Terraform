# Create VPC
resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "terraform_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

# Public Subnet A
resource "aws_subnet" "pb_sbnt_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_1
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Public_subnet_A"
  }
}

# Public Subnet B
resource "aws_subnet" "pb_sbnt_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_2
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Public_subnet_B"
  }
}

# Private Subnet A
resource "aws_subnet" "pr_sbnt_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_1
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private_subnet_A"
  }
}

# Private Subnet B
resource "aws_subnet" "pr_sbnt_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_2
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private_subnet_B"
  }
}

# Elastic ip
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "Elastic_ip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pb_sbnt_1.id

  tags = {
    Name = "NAT_gw"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Public Route Table 
resource "aws_route_table" "pb_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "pb-rt"
  }
}

# Public Route
resource "aws_route" "pb_r" {
  route_table_id            = aws_route_table.pb_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

# Route-Association Public A
resource "aws_route_table_association" "pb_rt_ass_1" {
  subnet_id      = aws_subnet.pb_sbnt_1.id
  route_table_id = aws_route_table.pb_rt.id
}

# Route-Association Public B
resource "aws_route_table_association" "pb_rt_ass_2" {
  subnet_id      = aws_subnet.pb_sbnt_2.id
  route_table_id = aws_route_table.pb_rt.id
}

# Private Route Table
resource "aws_route_table" "pr_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "pr-rt"
  }
}

# Private Route
resource "aws_route" "pr_r" {
  route_table_id            = aws_route_table.pr_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.nat.id
}

# Route-Association Private A
resource "aws_route_table_association" "pr_rt_ass_1" {
  subnet_id      = aws_subnet.pr_sbnt_1.id
  route_table_id = aws_route_table.pr_rt.id
}

# Route-Association Private B
resource "aws_route_table_association" "pr_rt_ass_2" {
  subnet_id      = aws_subnet.pr_sbnt_2.id
  route_table_id = aws_route_table.pr_rt.id
}

# Launch Template 
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-template-"

  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web-Server"
    }
  }

  tags = {
    Name = "Web-Launch-Template"
  }
}

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
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
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

# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  name             = "web-asg"
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.pr_sbnt_1.id,
    aws_subnet.pr_sbnt_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.web_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300
}