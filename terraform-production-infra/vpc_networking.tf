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
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_subnet_A"
  }
}

# Public Subnet B
resource "aws_subnet" "pb_sbnt_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_2
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

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

# Elastic ip 1
resource "aws_eip" "eip_1" {
  domain = "vpc"

  tags = {
    Name = "Elastic_ip_1"
  }
}

# Elastic ip 2
resource "aws_eip" "eip_2" {
  domain = "vpc"

  tags = {
    Name = "Elastic_ip_2"
  }
}

# NAT Gateway 1
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.pb_sbnt_1.id

  tags = {
    Name = "NAT_gw_1"
  }

  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway 2
resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.eip_2.id
  subnet_id     = aws_subnet.pb_sbnt_2.id

  tags = {
    Name = "NAT_gw_2"
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

# Private Route Table 1
resource "aws_route_table" "pr_rt_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "pr-rt_1"
  }
}

# Private Route Table 2
resource "aws_route_table" "pr_rt_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "pr-rt_2"
  }
}

# Private Route 1
resource "aws_route" "pr_r_1" {
  route_table_id            = aws_route_table.pr_rt_1.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id                = aws_nat_gateway.nat_1.id
}

# Private Route 2
resource "aws_route" "pr_r_2" {
  route_table_id            = aws_route_table.pr_rt_2.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id                = aws_nat_gateway.nat_2.id
}

# Route-Association Private A
resource "aws_route_table_association" "pr_rt_ass_1" {
  subnet_id      = aws_subnet.pr_sbnt_1.id
  route_table_id = aws_route_table.pr_rt_1.id
}

# Route-Association Private B
resource "aws_route_table_association" "pr_rt_ass_2" {
  subnet_id      = aws_subnet.pr_sbnt_2.id
  route_table_id = aws_route_table.pr_rt_2.id
}


