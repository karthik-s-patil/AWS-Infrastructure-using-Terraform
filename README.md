# AWS Infrastructure using Terraform

## Overview

This project provisions a production-style AWS infrastructure using Terraform. It automates the creation of networking, security, compute, load balancing, and auto scaling resources following Infrastructure as Code (IaC) principles.

---

## Technologies Used

- Terraform
- AWS VPC
- Amazon EC2
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Security Groups
- Internet Gateway
- NAT Gateway

---

## Deployment Steps

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Provision the infrastructure:

```bash
terraform apply
```

Destroy the infrastructure:

```bash
terraform destroy
```

---

## Features

- Infrastructure as Code (IaC)
- Multi-AZ Deployment
- Public and Private Subnets
- Secure Networking
- Application Load Balancer
- Auto Scaling
- Automated EC2 Provisioning

---

## Learning Outcomes

- AWS Networking
- Terraform Fundamentals
- Infrastructure Automation
- Load Balancing
- Auto Scaling
- Cloud Security
