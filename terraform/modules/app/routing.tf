resource "aws_lb_target_group" "eloquent" {
  name        = "${var.service_name}-ecs-tg"
  port        = var.service_port
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    timeout             = local.health_check_timeout
    interval            = local.health_check_interval
    port                = var.service_port
    protocol            = "HTTP"
    path                = local.health_check_path 
    healthy_threshold   = local.health_check_healthy_threshold
    unhealthy_threshold = local.health_check_unhealthy_threshold
    matcher             = "200-399" 
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.service_name}-tg"
  }
}
