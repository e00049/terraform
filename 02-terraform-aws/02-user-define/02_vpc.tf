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

resource "aws_subnet" "dev-public-subnet" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "192.168.1.0/26"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-subnet"
    env  = "dev"
  }
}

resource "aws_route_table_association" "association-rt-subnet" {
  subnet_id      = aws_subnet.dev-public-subnet.id
  route_table_id = aws_route_table.dev-public-rt.id
}
