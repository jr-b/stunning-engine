# Following this guide : https://www.scottyfullstack.com/blog/devops-01-aws-terraform-ansible-jenkins-and-docker/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
# Define the region
provider "aws" {
    region = "us-east-1"
}

# Using this documentation: https://blog.gruntwork.io/a-crash-course-on-terraform-5add0d9ef9b4
# Create the security group allowing inbound SSH and HTTP traffic
resource "aws_security_group" "instance" {
  name = "terraform-jekins-docker"
  description = "allow inbound traffic for SSH (any IP) and HTTP (only from my IP)"
  
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
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.23.130/32"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Create the EC2 for Jenkins
resource "aws_instance" "jenkins" {

    ami = "ami-0022f774911c1d690"
    instance_type = "t2.micro"
    key_name = "us-east1-kpair"

    vpc_security_group_ids = [aws_security_group.instance.id]
    
    tags = {
        Name = "jenkins"
    }

}

#Create the EC2 for Docker web server
resource "aws_instance" "docker-web-server" {

    ami = "ami-0022f774911c1d690"
    instance_type = "t2.micro"
    key_name = "us-east1-kpair"
    
    vpc_security_group_ids = [aws_security_group.instance.id]

    tags = {
        Name = "docker-web-server"
    }

}