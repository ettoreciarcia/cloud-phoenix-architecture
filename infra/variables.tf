
variable "tags" {
  type        = map(string)
  default     = {}
  description = "List tags to pass to resources"
}

variable "load_balancer_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}