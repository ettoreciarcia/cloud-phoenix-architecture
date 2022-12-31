application_name = "cloud-phoenix"
environment      = "dev"

cidr =  "10.100.0.0/16"
azs = ["eu-central-1"]
region = "eu-central-1"
public_subnets = ["10.100.10.0/24", "10.100.20.0/24", "10.100.30.0/24"]
private_subnets = ["10.100.11.0/24", "10.100.21.0/24", "10.100.31.0/24"]
database_subnets = ["10.100.12.0/24", "10.100.22.0/24", "10.100.32.0/24"]
