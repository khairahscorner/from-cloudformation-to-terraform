output "app_sg" {
  value = aws_security_group.app_servers_security_group.id
}

output "lb_sg" {
  value = aws_security_group.load_balancer_security_group.id
}

output "profile" {
  value = aws_iam_instance_profile.ec2_role_profile.arn
}
