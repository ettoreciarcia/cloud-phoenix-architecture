variable "application_name" {
  type    = string
  description = "Name of the application"
}

variable "environment" {
  type = string
  description = "Environment of the application dev/test/prod"
}

variable "region" {
  # default = "eu-central-1"
  type = string
}

variable "azs" {
  type = list(string)
  description = "List of Availability Zones"
  # default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "cidr" {
  type        = string
  # default = "10.100.0.0/16"
  description = ""
}

variable "public_subnets" {
  type        = list(string)
  # default = ["10.100.10.0/24", "10.100.20.0/24", "10.100.30.0/24"]
  description = ""
}
variable "private_subnets" {
  type        = list(string)
  # default = ["10.100.11.0/24", "10.100.21.0/24", "10.100.31.0/24"]
  description = ""
}

variable "database_subnets" {
  type        = list(string)
  # default = ["10.100.12.0/24", "10.100.22.0/24", "10.100.32.0/24"]

  description = "The subnets associated with the task or service"
}
