variable "env" {
  description = "Resource Envviroment"
  type        = string
  default     = "dev"
}

variable "list-servers" {
  description = "List of Servers"
  type        = list(any)
  default     = ["server-001", "server-002"]
}

variable "Env" {
  type = map(any)
  default = ({
    dev  = "Server"
    prod = "Server"
  })
}

// -----------------------------------
  
# Custom VPC
resource "aws_vpc" "custom-vpc" {
  cidr_block           = "192.168.1.0/24"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.env}-custom-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom-vpc.id
  tags = {
    Name = "${var.env}-igw"
  }
}

# Public Route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

# Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "192.168.1.0/26"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.env}-public-subnet"
  }
}

# Public Subnet associate with Public route Table
resource "aws_route_table_association" "subent-rtb-associate" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

// All traffic Security group 
resource "aws_security_group" "all-traffic" {
  name        = "all-traffic"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.custom-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-all-traffic"
  }
}

# Public EC2 Linux Instance 
resource "aws_instance" "e00049-Linux-Server" {
  count         = length(var.list-servers)
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name      = "e00049-DevOps-Tools-Key"
  // user_data              = file("webserver.sh")
  vpc_security_group_ids = [aws_security_group.all-traffic.id]
  subnet_id              = aws_subnet.public-subnet.id

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "${var.env}-server-${count.index + 1}"
  }
}
