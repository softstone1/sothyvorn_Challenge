provider "aws" {
  region = "us-east-1"
}

// key pair from the public key
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-deployer-key"
  public_key = file("${var.public_key_path}")
}

resource "aws_security_group" "web" {
  name        = "terraform-example-web"
  // Allow SSH for local machine
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

resource "aws_instance" "web" {
  ami                    = "ami-058bd2d568351da34"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "WebServer"
  }

// cloud-init to setup the web server with Ansible
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y ansible git
    ansible-pull -U https://github.com/softstone1/sothyvorn_Challenge.git webserver-setup.yaml -e 'email_id=${var.email_id}' -vvv
    EOF
}

output "web_instance_ip" {
  value = aws_instance.web.public_ip
}
