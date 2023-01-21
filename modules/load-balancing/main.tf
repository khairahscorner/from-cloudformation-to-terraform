
# resource "aws_s3_bucket" "lb_logs_bucket" {
#   bucket = "lb-logs-terraform"
#   tags = {
#     Name = "LoadBalancer logs via Terraform"
#   }
# }

# resource "aws_s3_bucket_acl" "lb_bucket_acl" {
#   bucket = aws_s3_bucket.lb_logs_bucket.id
#   acl    = "private"
# }

resource "aws_lb" "load_balancer" {
  name               = "LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            = var.public_sub_ids

  idle_timeout = 200

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs_bucket.bucket
  #     prefix  = "loadbalancer-logs"
  #     enabled = true
  #   }
  depends_on = [
    var.vpc_id
  ]
}

resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }
}

resource "aws_lb_listener_rule" "alb_rule" {
  listener_arn = aws_lb_listener.load_balancer_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
