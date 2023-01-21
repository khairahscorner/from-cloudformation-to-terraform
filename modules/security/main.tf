

resource "aws_security_group" "app_servers_security_group" {
  name        = "AppServersSecurityGroup"
  description = "security group for the servers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "app_sg"
  }
  lifecycle {
    # Necessary if changing 'name' or 'name_prefix' properties.
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  description       = "allow access incoming http traffic"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_servers_security_group.id
}
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  description       = "allow access incoming http ssh traffic"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_servers_security_group.id
}
resource "aws_security_group_rule" "allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  description       = "permit all outgoing traffic from all ports"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_servers_security_group.id
}


resource "aws_security_group" "load_balancer_security_group" {
  name        = "LoadBalancerSecurityGroup"
  description = "security group for load balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "allow access incoming http traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "permit outgoing http traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id
  tags = {
    Name = "lb_sg"
  }
  lifecycle {
    # Necessary if changing 'name' or 'name_prefix' properties.
    create_before_destroy = true
  }
}


data "aws_iam_policy_document" "instance_assume_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "s3_read_only_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role" "ec2_s3_read_only" {
  name                = "UdacityS3ReadOnlyEC2Role"
  description         = "Role for read only access to s3"
  assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.s3_read_only_policy.arn]

  max_session_duration = 14400
  tags = {
    Name = "ec2_role"
  }
}

resource "aws_iam_instance_profile" "ec2_role_profile" {
  name = "UdacityReadOnlyProfile"
  role = aws_iam_role.ec2_s3_read_only.name
}
