provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-deployer-key"
  public_key = file("${var.public_key_path}")
}

# Fetch information about an existing key pair on AWS
data "aws_key_pair" "deployer" {
  key_name = "terraform-deployer-key"
}

resource "aws_security_group" "web" {
  name        = "terraform-example-web"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  connection {
    type        = "ssh"
    user        = "debian"  
    private_key = file("${var.private_key_path}")
    host        = self.public_ip  
  }

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y git
    sudo apt-get install -y ansible
    ansible-pull -U https://github.com/softstone1/sothyvorn_Challenge.git -d /tmp/ansible webserver-setup.yaml -e 'email_id=${var.email_id}'
    EOF
}

output "web_instance_ip" {
  value = aws_instance.web.public_ip
}
