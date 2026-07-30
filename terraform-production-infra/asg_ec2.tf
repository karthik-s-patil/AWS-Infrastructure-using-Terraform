# Launch Template 
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-template-"

  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  user_data = base64encode(<<-EOF
   #!/bin/bash
   apt-get update -y
   apt-get install -y nginx

  systemctl enable nginx
  systemctl start nginx

   echo "<h1>Welcome from Auto Scaling Group</h1>" > /var/www/html/index.html
  EOF
  )

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

