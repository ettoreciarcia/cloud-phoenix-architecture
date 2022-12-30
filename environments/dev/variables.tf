variable "application_name" {
  type    = string
  description = "Name of the application"
}

variable "environment" {
  type = string
  description = "Environment of the application dev/test/prod"
}

variable "vpc_cidr" {
  type        = string
  default = "10.100.0.0/16"
  description = "VPC CIDR"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}
variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
}

variable "database_subnets" {
  type        = list(string)
  description = "Database subnets"
}

