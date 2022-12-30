
locals {
  common_tags = {
    Application = var.application_name
    Environment = var.environment
  }
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "hechaorganization"
    workspaces {
      name = "cloud-phoenix-infra"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  # default_tags {
  #   tags = local.common_tags
  # }
}

module "components-cloud-phoenix-architecture" {
  source = "../../infra"
}

# module "middleware" {
#   source = "../../middleware"

#   name = "VPC-${var.application_name}-${var.environment}"
#   azs = var.azs
#   cidr = var.vpc_cidr
#   public_subnets = var.public_subnets
#   private_subnets = var.app_private_subnets
#   intra_subnets = var.db_private_subnets

#   # Tagging/naming resources
#   public_subnet_suffix = "PublicSubnet"
#   private_subnet_suffix = "AppPrivateSubnet"
#   intra_subnet_suffix = "DataPrivateSubnet"

#   # Single NAT Gateway
#   # The NAT gateway will be placed in the first public subnet in public_subnets block
#   enable_nat_gateway = true
#   single_nat_gateway = true
#   one_nat_gateway_per_az = false
#   reuse_nat_ips = true
#   external_nat_ip_ids = [aws_eip.nat.id]

#   # DNS
#   enable_dns_support = var.enable_dns_support
#   enable_dns_hostnames = var.enable_dns_hostnames
#   instance_tenancy = var.instance_tenancy
#   dhcp_options_domain_name = var.domain_name
#   dhcp_options_domain_name_servers = var.domain_name_servers

#   tags = var.tags
# }