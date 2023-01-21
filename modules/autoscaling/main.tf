

resource "aws_launch_template" "servers_launch_template" {
  name          = "ServersLaunchTemplate"
  image_id      = var.launch_ami
  key_name      = var.key_name
  instance_type = var.instance_type

  vpc_security_group_ids               = [var.ec2_sg_id]
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = filebase64("${path.module}/ec2.sh")

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 10
    }
  }
  iam_instance_profile {
    arn = var.iam_profile
  }
}

resource "aws_lb_target_group" "servers_target_group" {
  name        = "ServersTargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 150
    timeout             = 120
    path                = "/"
    protocol            = "HTTP"
  }
}

resource "aws_autoscaling_group" "servers_auto_scaling_group" {
  name                = "ServersAutoScalingGroup"
  max_size            = 6
  min_size            = 4
  vpc_zone_identifier = var.zone_identifiers

  launch_template {
    id      = aws_launch_template.servers_launch_template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.servers_target_group.arn]
  health_check_type = "EC2"

  depends_on = [
    var.vpc_id
  ]
}
