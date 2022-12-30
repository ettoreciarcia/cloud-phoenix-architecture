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