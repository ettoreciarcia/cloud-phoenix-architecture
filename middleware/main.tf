locals {
  application_name = var.tags["Application"]
  environment = var.tags["Environment"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_name
  azs = var.azs
  cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.app_private_subnets
  intra_subnets = var.db_private_subnets

  # Tagging/naming resources
  public_subnet_suffix = "PublicSubnet"
  private_subnet_suffix = "AppPrivateSubnet"
  intra_subnet_suffix = "DataPrivateSubnet"

  # Single NAT Gateway
  # The NAT gateway will be placed in the first public subnet in public_subnets block
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  reuse_nat_ips = true
  external_nat_ip_ids = [aws_eip.nat.id]

  # DNS
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = var.instance_tenancy
  dhcp_options_domain_name = var.domain_name
  dhcp_options_domain_name_servers = var.domain_name_servers

  tags = var.tags
}

# Elastic IP
resource "aws_eip" "nat" {
  vpc = true
}
