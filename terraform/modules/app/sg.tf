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

resource "aws_vpc_security_group_egress_rule" "sg_egress_alb" {
  security_group_id = aws_security_group.sg_service_alb.id

  cidr_ipv4   = "0.0.0.0/0"
  cidr_ipv6   = "::/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}

resource "aws_security_group" "sg_service" {
  name   = "${var.service_name}-service-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.service_name}-service-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_service_ingress" {
  security_group_id = aws_security_group.sg_service.id

  referenced_security_group_id   = aws_security_group.sg_service_alb.id
  from_port   = var.service_port
  ip_protocol = "tcp"
  to_port     = var.service_port
}

resource "aws_vpc_security_group_egress_rule" "sg_service_egress" {
  security_group_id = aws_security_group.sg_service_alb.id

  cidr_ipv4   = "0.0.0.0/0"
  cidr_ipv6   = "::/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}