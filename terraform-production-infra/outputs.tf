############################
# outputs.tf
############################

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value = [
    aws_subnet.pb_sbnt_1.id,
    aws_subnet.pb_sbnt_2.id
  ]
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value = [
    aws_subnet.pr_sbnt_1.id,
    aws_subnet.pr_sbnt_2.id
  ]
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat.id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.pb_rt.id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = aws_route_table.pr_rt.id
}

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2_sg.id
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.web_lt.id
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.alb.dns_name
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.web_tg.arn
}

output "listener_arn" {
  description = "Listener ARN"
  value       = aws_lb_listener.http_listener.arn
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group Name"
  value       = aws_autoscaling_group.web_asg.name
}