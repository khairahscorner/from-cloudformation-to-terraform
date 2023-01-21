output "load_balancer_url" {
  value = aws_lb.load_balancer.dns_name
}
