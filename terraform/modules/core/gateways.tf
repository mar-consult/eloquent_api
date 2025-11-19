resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.name}-igw"
  }
}

resource "aws_eip" "nat_ip" {
  for_each = { for s in aws_subnet.public : s.availability_zone => s }

  domain = "vpc"

  tags = {
    Name = "${var.environment}-${var.name}-eip-nat-${each.key}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = { for s in aws_subnet.public : s.availability_zone => s }

  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.nat_ip[each.key].id

  tags = {
    Name = "${var.environment}-${var.name}-nat-${each.key}"
  }
}
