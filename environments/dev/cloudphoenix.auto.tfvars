application_name = "cloud-phoenix"
environment      = "dev"

cidr =  "10.100.0.0/16"
azs  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
region = "eu-central-1"
public_subnets = ["10.100.10.0/24", "10.100.20.0/24", "10.100.30.0/24"]
private_subnets = ["10.100.11.0/24", "10.100.21.0/24", "10.100.31.0/24"]
database_subnets = ["10.100.12.0/24", "10.100.22.0/24", "10.100.32.0/24"]
