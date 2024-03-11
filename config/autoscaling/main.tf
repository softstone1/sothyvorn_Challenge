provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-deployer-key"
  public_key = file("${var.public_key_path}")
}

resource "aws_security_group" "web" {
  name        = "terraform-example-web"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["104.28.201.199/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-example-web"
  }
}

resource "aws_launch_configuration" "web" {
  name          = "web-launch-configuration"
  image_id      = "ami-058bd2d568351da34"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.web.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y ansible git
    ansible-pull -U https://github.com/softstone1/sothyvorn_Challenge.git webserver-setup.yaml -e 'email_id=${var.email_id}' -vvv
    EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1
  launch_configuration = aws_launch_configuration.web.id
  vpc_zone_identifier  = [aws_subnet.example.id]

  tag {
    key                 = "Name"
    value               = "WebServer"
    propagate_at_launch = true
  }
}

resource "aws_elb" "web" {
  name               = "terraform-example-elb"
  subnets            = [aws_subnet.example.id]
  security_groups    = [aws_security_group.web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances           = [aws_instance.web.id]
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  elb                    = aws_elb.web.id
}