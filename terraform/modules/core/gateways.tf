resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_eip" "nat_ip" {
  count = length(aws_subnet.public)

  domain = "vpc"

  tags = {
    Name = "${var.name}-eip-nat-${aws_subnet.public[count.index].id}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = length(aws_subnet.public)

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat_ip[count.index].id

  tags = {
    Name = "${var.name}-nat-${aws_subnet.public[count.index].id}"
  }
}
