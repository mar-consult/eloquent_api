locals {
  private_azs = toset([for s in var.private_subnets : s.availability_zone])
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.name}-public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = { for s in var.public_subnets : s.availability_zone => s }

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = { for s in local.private_azs : s => s }

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.name}-private-${each.key}"
  }
}

resource "aws_route" "private" {
  for_each = { for s in aws_subnet.public : s.availability_zone => s }

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[each.key].id
  nat_gateway_id         = aws_nat_gateway.nat[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = { for s in var.private_subnets : s.cidr_block => s }

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.value.availability_zone].id
}
