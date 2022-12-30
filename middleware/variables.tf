
variable "tags" {
  type = map(string)
  default = {}
  description = "List tags to pass to resources"
}

variable "vpc_name" {
  type = string
  description = "Name to assign to the VPC"
}

variable "vpc_cidr" {
  type = string
  description = "CIDR of the VPC"
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
  description = "List of Availability Zones"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "public_subnets" {
  type = list(string)
  description = "List of public subnets"
  default = ["10.0.1.0", "10.0.2.0", "10.0.3.0"]
}

variable "app_private_subnets" {
  type = list(string)
  description = "List of application private subnets"
  default = ["10.0.10.0", "10.0.11.0", "10.0.12.0"]
}

variable "db_private_subnets" {
  type = list(string)
  description = "List of database private subnets"
  default = ["10.0.20.0", "10.0.21.0", "10.0.22.0"]
}

variable "enable_dns_support" {
  type = bool
  description = "Enable Dns Support"
  default = true
}

variable "enable_dns_hostnames" {
  type = bool
  description = "Enable Dns Hostnames"
  default = true
}

variable "instance_tenancy" {
  type = string
  default = "default"
  description = "The desired tenancy of the instances"

  validation {
    condition = (
    var.instance_tenancy == "default" ||
    var.instance_tenancy == "dedicated" ||
    var.instance_tenancy == "host"
    )

    error_message = "The tenancy value must be [default,dedicated,host]."
  }
}

variable "domain_name" {
  type = string
  description = "DHCP DomainName"
  default = "eu-west-1.compute.internal"
}

variable "domain_name_servers" {
  type = list(string)
  description = "List of name servers"
  default = ["AmazonProvidedDNS"]
}
