terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # you can change this on your choice
}

resource "aws_instance" "Jenkins-CICD" {
  ami           = "ami-0cd59ecaf368e5ccf"  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  instance_type = "t2.medium"
  key_name      = "aws-sinem" # Update with your key pair name
  user_data = file("userdata.sh")
  security_groups = [aws_security_group.jenkins_security_group.name]
  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_security_group" "jenkins_security_group" {
  name        = "Jenkins-CICD-Project"
  description = "Allow SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8082
    to_port     = 8082
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
    Name = "Jenkins-CiCd-Server"
  }
}


output "instance_public_ip" {
  value = aws_instance.Jenkins-CICD.public_ip
}

