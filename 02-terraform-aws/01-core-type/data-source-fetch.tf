provider "aws" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "working" {}


data "aws_vpc" "prod" {
  tags = {
    env = "prod"
  }
}

resource "aws_subnet" "public_subnet-01" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "192.168.2.0/26"
  availability_zone = data.aws_availability_zones.working.name[0]

  tags = {
    env  = "prod"
    Name = "public_subnet_01"
  }
}

resource "aws_subnet" "public_subnet-02" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "192.168.2.64/26"
  availability_zone = data.aws_availability_zones.working.name[1]

  tags = {
    env  = "prod"
    Name = "public_subnet_02"
  }
}

output "region_name" {
  value = data.aws_region.current
}

output "accound_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.working
}
