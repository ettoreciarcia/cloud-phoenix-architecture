
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

  tags              = local.common_tags
  load_balancer_arn = module.middleware.load_balancer_arn
  vpc_id            = module.middleware.vpc_id
  private_subnets   = module.middleware.private_subnets
  host_header       = var.host_header
  region            = var.region
}

module "middleware" {
  source = "../../middleware"

  azs              = var.azs
  cidr             = var.cidr
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets


  tags = local.common_tags
}

