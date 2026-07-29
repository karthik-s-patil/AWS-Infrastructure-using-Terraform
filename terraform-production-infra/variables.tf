variable "aws_region" {
  description = "AWS Region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "key_name" {
  description = "Existing EC2 Key Pair name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for the pb-sbnt-A"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for the pb-sbnt-B"
  type        = string
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for the pr-sbnt-A"
  type        = string
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the pr-sbnt-B"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "key_pair_name" {
  description = "EC2 Key Pair Name"
  type        = string
}