
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

module "middleware" {
  source = "../../middleware"

  
  azs = var.azs
  cidr = var.cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  database_subnets = var.database_subnets


  tags = local.common_tags
}

module infra {
  source = "../../infra"

  

  tags = local.common_tags
}