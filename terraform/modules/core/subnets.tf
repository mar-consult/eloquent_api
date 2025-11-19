resource "aws_subnet" "private" {
  for_each = { for s in var.private_subnets : s.cidr_block => s }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.key
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${var.environment}-${var.name}-${each.value.name}"
  }
}

resource "aws_subnet" "public" {
  for_each = { for s in var.public_subnets : s.availability_zone => s }

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-${var.name}-${each.value.name}"
  }
}

locals {
  private_subnet_ids   = [for s in aws_subnet.private : s.id]
  public_subnet_ids    = [for s in aws_subnet.public : s.id]
  public_subnet_cidrs  = [for s in aws_subnet.public : s.cidr_block]
  private_subnet_cidrs = [for s in aws_subnet.private : s.cidr_block]
}
