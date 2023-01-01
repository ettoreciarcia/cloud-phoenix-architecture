locals {
  application_name = var.tags["Application"]
  environment = var.tags["Environment"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = format("VPC-%s-%s", local.application_name, local.environment)
  cidr = var.cidr
  azs = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  intra_subnets   = var.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  reuse_nat_ips = true
  external_nat_ip_ids = [aws_eip.nat.id]
}

# Elastic IP
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_security_group" "alb-sg" {
  name        = "${local.application_name}-${local.environment}-alb-sg"
  description = "Security group for alb"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb" "alb" {
  name               = "alb-${local.application_name}-${local.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [for id in module.vpc.public_subnets : id]

  ip_address_type            = "ipv4"
  idle_timeout                = 60
  enable_deletion_protection = false

  tags = var.tags
}

