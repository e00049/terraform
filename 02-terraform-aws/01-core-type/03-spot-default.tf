resource "aws_spot_instance_request" "e00049-DevOps-Jenkins" {
  spot_price             = "0.1"
  wait_for_fulfillment   = true
  spot_type              = "one-time"
  ami                    = "ami-0729e439b6769d6ab"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default-subnet.id
  key_name               = "devops-tools-key"
  vpc_security_group_ids = [data.aws_security_group.default-securitygroup.id]

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "linux-apache-webserver"
    env  = "dev"
  }
}

data "aws_vpc" "default-vpc" {
  default = true
}

data "aws_subnet" "default-subnet" {
  vpc_id            = data.aws_vpc.default-vpc.id
  availability_zone = "us-east-1a"
}

data "aws_security_group" "default-securitygroup" {
  vpc_id = data.aws_vpc.default-vpc.id
  filter {
    name   = "group-name"
    values = ["all-traffic-terrform"]
  }
}
