
resource "aws_vpc" "dev-vpc" {
  cidr_block           = "192.168.1.0/24"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev-vpc"
    env  = "dev"
  }
}

resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "dev-gw"
    env  = "dev"
  }
}

resource "aws_route_table" "dev-public-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  tags = {
    Name = "dev-public-rt"
    env  = "dev"
  }
}

data "aws_availability_zones" "available" { # 01. data rources block
  state = "available"
}

resource "aws_subnet" "dev-public-subnet-01" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "192.168.1.0/26"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-subnet-01"
    env  = "dev"
  }
}

resource "aws_subnet" "dev-public-subnet-02" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "192.168.1.64/26"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-subnet-02"
    env  = "dev"
  }
}

resource "aws_route_table_association" "association-rt-subnet-01" {
  subnet_id      = aws_subnet.dev-public-subnet-01.id
  route_table_id = aws_route_table.dev-public-rt.id
}

resource "aws_route_table_association" "association-rt-subnet-02" {
  subnet_id      = aws_subnet.dev-public-subnet-02.id
  route_table_id = aws_route_table.dev-public-rt.id
}
