
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = var.eip_id
  subnet_id     = var.private_sub_ids[0]

  tags = {
    Name = "NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.ig_id]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "public route table"
  }
}
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.ig_id
  depends_on             = [aws_route_table.public_route_table]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "private route table"
  }
}
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  depends_on             = [aws_route_table.private_route_table]
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public_route_table.id

  for_each  = toset(var.public_sub_ids)
  subnet_id = each.key
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private_route_table.id

  for_each  = toset(var.private_sub_ids)
  subnet_id = each.key
}
