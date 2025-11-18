resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index].cidr_block
  availability_zone = var.private_subnets[count.index].availability_zone

  tags = {
    Name = "${var.name}-subnet-${var.private_subnets[count.index].name}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index].cidr_block
  availability_zone       = var.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-subnet-${var.public_subnets[count.index].name}"
  }
}

locals {
  private_subnet_ids   = aws_subnet.private.*.id
  public_subnet_ids    = aws_subnet.public.*.id
}
