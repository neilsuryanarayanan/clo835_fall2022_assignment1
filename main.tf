provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "assignvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_internet_gateway" "assignigw" {
  vpc_id = aws_vpc.assignvpc.id

  tags = {
    Name = "assign-igw"
  }
}

resource "aws_route_table" "assign_route_table" {
  vpc_id = aws_vpc.assignvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.assignigw.id
  }
  tags = {
    Name = "assign_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.assign_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_subnet" "public_subnet" {
vpc_id     = aws_vpc.assignvpc.id
cidr_block = "10.0.0.0/24"
map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_security_group" "instance" {
  name        = "instance1-instance-sg"
  description = "Allow SSH access and http"
  vpc_id     = aws_vpc.assignvpc.id

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


# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["ami-0aa7d40eeae50c9a9"]
#   }
# }

resource "aws_instance" "instance1" {
  ami           = "ami-0aa7d40eeae50c9a9"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance.id]
  iam_instance_profile = "LabInstanceProfile"
  key_name = "clo835"
  
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