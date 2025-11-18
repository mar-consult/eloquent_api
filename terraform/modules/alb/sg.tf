resource "aws_security_group" "sg_service_alb" {
  name = var.name
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-sg-service-alb"
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