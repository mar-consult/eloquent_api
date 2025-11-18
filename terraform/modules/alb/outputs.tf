output "alb" {
  value = {
    arn               = aws_lb.alb.arn
    dns_name          = aws_lb.alb.dns_name
    security_group_id = aws_security_group.sg_service_alb.id
    arn_suffix        = aws_lb.alb.arn_suffix
  }
}
