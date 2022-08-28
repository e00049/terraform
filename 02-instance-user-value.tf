# access, secret keys and region are configured as environment variables

# Create VPC 
resource "aws_vpc" "e00049-VPC-WebServer" {
  cidr_block           = "192.168.1.0/24"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "e00049-VPC-WebServer"
  }
}

# Create Internet-GateWay
resource "aws_internet_gateway" "e00049-IGW-Public" {
  vpc_id = aws_vpc.e00049-VPC-WebServer.id
  tags = {
    Name = "e00049-IGW-Public"
  }
}

# Public Subnet  
resource "aws_subnet" "e00049-Subnet-Public" {
    vpc_id                  = aws_vpc.e00049-VPC-WebServer.id
    cidr_block              = "192.168.1.0/26"
    map_public_ip_on_launch = "true" 
    availability_zone       = "us-east-1a" 

    tags = {
        Name = "e00049-Subnet-Public"
    }
}

# Public Route Table
resource "aws_route_table" "e00049-Public-RT" {
  vpc_id = aws_vpc.e00049-VPC-WebServer.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.e00049-IGW-Public.id
  }
  tags = {
    Name = "e00049-Public-RT"
  }
}

# Route Table and subnet Association 
resource "aws_route_table_association" "e00049-RTA-Public" {
  subnet_id      = aws_subnet.e00049-Subnet-Public.id
  route_table_id = aws_route_table.e00049-Public-RT.id
}

# Create Security Group for SSH and HTTP 
resource "aws_security_group" "e00049-SG-WebServer" {
  name        = "e00049-SG-WebServer"
  description = "Allow WebServer Inbound traffic"
  vpc_id      = aws_vpc.e00049-VPC-WebServer.id

  ingress {
    description      = "SSH protocol"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP protocol"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "e00049-SG-WebServer"
  }
}

# Create EC2 Instance 
resource "aws_instance" "e00049-EC2-WebServer" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.e00049-Subnet-Public.id
  key_name      = "e00049-ec2-key"
  user_data     = "${file("webserver.sh")}"                 
  vpc_security_group_ids = [aws_security_group.e00049-SG-WebServer.id]  

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "e00049-EC2-WebServer"
  }
}
