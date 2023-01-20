
data "aws_availability_zones" "available_azs" {
  state = "available"
}

resource "aws_vpc" "VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment_name}"
  }
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.environment_name}-internet gateway"
  }
}

# unlike CF, no need to do this if vpc_id is added when adding IG 
# resource "aws_internet_gateway_attachment" "vpc_iga" {
#   internet_gateway_id = aws_internet_gateway.internet_gateway.id
#   vpc_id              = aws_vpc.VPC.id
# }

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.VPC.id

  for_each = toset(var.public_subnets_cidr)

  cidr_block = each.key
  # index of subnet being created and use that to pick an AZ (0 or 1)
  availability_zone       = data.aws_availability_zones.available_azs.names[index(var.public_subnets_cidr, each.key)]
  map_public_ip_on_launch = true
  tags = {
    # Name = "${var.environment_name} public Subnet ${index(var.public_subnets_cidr, each.key)}"
    Name = "public subnets"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.VPC.id

  for_each = toset(var.private_subnets_cidr)

  cidr_block = each.key
  # index of subnet being created and use that to pick an AZ (0 or 1)
  availability_zone       = data.aws_availability_zones.available_azs.names[index(var.private_subnets_cidr, each.key)]
  map_public_ip_on_launch = false
  tags = {
    # Name = "${var.environment_name} Private Subnet ${index(var.private_subnets_cidr, each.key)}"
    Name = "private subnets"
  }
}

resource "aws_eip" "my_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
}

