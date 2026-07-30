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

