
variable "tags" {
  type        = map(string)
  default     = {}
  description = "List tags to pass to resources"
}

variable "region" {
  type = string
}

variable "load_balancer_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "host_header" {
  type = string
}