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
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  database_subnets = var.database_subnets
}
