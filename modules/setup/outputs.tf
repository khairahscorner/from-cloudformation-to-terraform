output "vpc_id" {
  value = aws_vpc.VPC.id
}

output "ig_id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "eip_id" {
  value = aws_eip.my_eip.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}
output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}
