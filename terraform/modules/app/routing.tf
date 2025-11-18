resource "aws_security_group" "sg_service_alb" {
  name   = "${var.service_name}-alb-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.service_name}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_service_alb_http" {
  count = var.enable_http ? length(var.allow_ingress_lb_cidr_block) : []
  security_group_id = aws_security_group.sg_service_alb.id

  cidr_ipv4   = var.allow_ingress_lb_cidr_block[count.index]
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "sg_service_alb_https" {
  count = var.enable_https ? length(var.allow_ingress_lb_cidr_block) : []
  security_group_id = aws_security_group.sg_service_alb.id
  cidr_ipv4   = var.allow_ingress_lb_cidr_block[count.index]
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.sg_service_alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_security_group" "sg_service" {
  name   = "${var.service_name}-service-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.service_name}-service-sg"
  }
}

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
    name = "${var.service_name}-tg"
  }
}
