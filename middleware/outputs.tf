output "load_balancer_arn" {
  value = aws_lb.alb.arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
  
