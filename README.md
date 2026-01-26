# 2-Tier Web Application on AWS (Terraform)
![Project Image](https://github.com/efritznel/2-tier-web-application/blob/main/2tier%20diagram.gif)
# Overview

This project provisions a production-style 2-tier web application architecture on AWS using Terraform modules.
It demonstrates networking, security, scalability, and edge protection best practices, including ALB, Auto Scaling, RDS, WAF, and CloudFront.

The application is deployed in private subnets, exposed through a public Application Load Balancer, and fronted by CloudFront with AWS WAF.

# Architecture Summary

High-level flow:

CloudFront → WAF → ALB (public subnets) → EC2 (private subnets via ASG) → RDS (private subnets)

# Terraform Modules
# VPC Module

- VPC creation

- Internet Gateway

- 2 public subnets across different AZs

- 4 private subnets across different AZs

- Public route table and associations

# NAT Gateway Module

- 2 Elastic IPs (one per AZ)

- 2 NAT Gateways in public subnets

- Private route tables per AZ

- Private subnet associations

# ALB Module

- Internet-facing Application Load Balancer

- Target Group

- HTTP Listener on port 80

# Route 53 Module

- Public hosted zone for fritzhomelab.com

# Auto Scaling Group (ASG) Module

- Launch Template

- Auto Scaling Group

- CloudWatch alarms for CPU-based scale in/out

- config.sh bootstrap script:

    - Installs Apache

    - Deploys a basic web application

# WAF Module

- AWS Web Application Firewall

- Attached to CloudFront distribution

# Security Group Module

- ALB SG: allows inbound 80/443 from the internet

- Web App SG: allows inbound traffic only from ALB SG on port 80

- Database SG: allows inbound MySQL traffic only from Web App SG on port 3306

# RDS Module

- Secrets Manager for database credentials

- DB subnet group (private subnets)

- RDS instance deployment

# CloudFront Module

- ACM certificate request for www.fritzhomelab.com

- CloudFront distribution with ALB as origin

- WAF association

- HTTPS termination at the edge

# Key Pair Module

- EC2 SSH key pair management

# Prerequisites

- AWS account

- Terraform installed

- AWS CLI configured

- Domain name (fritzhomelab.com)

- IAM permissions for VPC, EC2, ALB, RDS, ACM, CloudFront, Route53, WAF

# Deployment Steps
terraform init

terraform plan

terraform apply

After deployment, Terraform outputs will include:

- ALB DNS name

- CloudFront distribution domain

- RDS endpoint

# ACM Certificate Validation (GoDaddy Domains)

If your domain is hosted on GoDaddy, follow these steps to validate the ACM certificate.

# Step 1 — Retrieve CNAME from ACM

- Open AWS Console → Certificate Manager

- Select the certificate for www.fritzhomelab.com

- Copy:

    - CNAME Name

    - CNAME Value

Example:

| Field | Example                        |
| ----- | ------------------------------ |
| Name  | `_abc123.www.fritzhomelab.com` |
| Value | `_xyz456.acm-validations.aws`  |

# Step 2 — Log in to GoDaddy

- Go to My Products

- Select DNS for fritzhomelab.com

# Step 3 — Add CNAME Record

| GoDaddy Field | Value                         |
| ------------- | ----------------------------- |
| Type          | CNAME                         |
| Name          | `_abc123.www`                 |
| Value         | `_xyz456.acm-validations.aws` |
| TTL           | Default                       |

ACM will validate automatically within a few minutes.

# Key Pair Setup

1. Create a .pem key pair in AWS

2. Convert it to .pub:

ssh-keygen -y -f new-keypair.pem > new-keypair.pub

3. Place:

- .pem file locally (never commit)

- .pub file inside:

    - modules/keypair

    - production/ folder

# Cleanup

terraform destroy

Note:

- Empty S3 buckets (if any)

- Ensure CloudFront distributions are fully disabled before destroy

# Key Takeaways

- Modular Terraform design

- Multi-AZ high availability

- Secure network segmentation

- Autoscaling and monitoring

- Edge protection with CloudFront + WAF

- Production-ready DNS and TLS
