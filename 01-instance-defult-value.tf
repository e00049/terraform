resource "aws_instance" "e00049-Apache-Webserver" {
  ami               = "ami-0729e439b6769d6ab"
  instance_type     = "t2.micro"
  subnet_id         = data.aws_subnet.e00049-default-subnet.id
  key_name          = "e00049-DevOps-Tools-Key"  
  vpc_security_group_ids = [data.aws_security_group.e00049-default-securitygroup.id]

  tags = {
    Name = "e00049-Apache-Webserver"
  }
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
}

data "aws_vpc" "e00049-default-vpc" {
  default = true
}

data "aws_subnet" "e00049-default-subnet" {
  vpc_id            = data.aws_vpc.e00049-default-vpc.id
  availability_zone = "us-east-1a"
}

data "aws_security_group" "e00049-default-securitygroup" {
  vpc_id = data.aws_vpc.e00049-default-vpc.id
  filter {
    name   = "group-name"
    values = ["e00049-DevOps-Tools"]
  }
}
