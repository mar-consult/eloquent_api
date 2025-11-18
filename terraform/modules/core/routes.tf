locals {
  public_subnets = { for s in aws_subnet.public : s.id => s }
  nat_az_to_id   = { for n in aws_nat_gateway.nat : local.public_subnets[n.subnet_id].availability_zone => n.id }
}

resource "aws_route_table" "public" {
  count = length(aws_subnet.public)

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-route-table-public-${aws_subnet.public[count.index].id}"
  }
}

resource "aws_route" "public" {
  count = length(aws_subnet.public)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public[count.index].id
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-route-table-private-${aws_subnet.private[count.index].id}"
  }
}

resource "aws_route" "private" {
  count = length(aws_subnet.private)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = local.nat_az_to_id[var.private_subnets[count.index].nat_az]
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
