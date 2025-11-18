resource "aws_lb" "alb" {
  name                             = "${var.service_name}-alb"
  internal                         = var.is_internal
  load_balancer_type               = "application"
  subnets                          = var.is_internal ? var.public_subnet_ids : var.private_subnet_ids
  enable_cross_zone_load_balancing = true
  security_groups                  = [aws_security_group.sg_service_alb.id]
  enable_deletion_protection       = true

  idle_timeout = 3600

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.service_name}-alb"
  }
}

resource "aws_lb_listener" "http" {
  count             = var.enable_http ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = var.enable_https_redirection ? [1] : []
    content {
      type = "redirect"

      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    
  }
}

resource "aws_lb_listener" "https_listener" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
      message_body = "Not Found"
    }
  }
}
