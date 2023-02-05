provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "public_subnet" {
vpc_id     = data.aws_vpc.default.id
cidr_block = "172.31.96.0/20"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_security_group" "instance" {
  name        = "instance1-instance-sg"
  description = "Allow SSH access and http"

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
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    
   ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

resource "aws_instance" "instance1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance.id]
  iam_instance_profile = "LabInstanceProfile"

  tags = {
    Name = "instance1"
  }
}

resource "aws_ecr_repository" "application_repository" {
  name = "application-repository"
}

resource "aws_ecr_repository" "database_repository" {
  name = "database-repository"
}