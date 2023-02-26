#----------------------------------------------------------
#  Terraform - From Zero to Certified Professional
#
# Lookup and Conditions
#
# Made by Denis Astahov
#----------------------------------------------------------
provider "aws" {
  region = "us-west-2"
}

data "aws_region" "current" {}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

resource "aws_instance" "my_server" {
  ami                    = var.ami_id_per_region[data.aws_region.current.name]
  instance_type          = lookup(var.server_size, var.env, var.server_size["my_default"])
  vpc_security_group_ids = [aws_security_group.my_server.id]

  root_block_device {
    volume_size = 10
    encrypted   = (var.env == "prod") ? true : false
  }

  dynamic "ebs_block_device" {
    for_each = var.env == "prod" ? [true] : []
    content {
      device_name = "/dev/sdb"
      volume_size = 40
      encrypted   = true
    }
  }

  volume_tags = { Name = "Disk-${var.env}" }
  tags        = { Name = "Server-${var.env}" }
}


resource "aws_security_group" "my_server" {
  name   = "My Server Security Group"
  vpc_id = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = lookup(var.allow_port, var.env, var.allow_port["rest"])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "My Server Dynamic SG"
    Owner = "Denis Astahov"
  }
}

variable "env" {
  default = "test"
}

variable "server_size" {
  default = {
    prod       = "t3.large"
    staging    = "t3.medium"
    dev        = "t3.small"
    my_default = "t3.nano"
  }
}

variable "ami_id_per_region" {
  description = "My Custom AMI id per Region"
  default = {
    "us-west-2"  = "ami-0e472933a1395e172"
    "us-west-1"  = "ami-08d9a394ac1c2994c"
    "eu-west-1"  = "ami-0ce1e3f77cd41957e"
    "ap-south-1" = "ami-08f63db601b82ff5f"
  }
}

variable "allow_port" {
  default = {
    prod = ["80", "443"]
    rest = ["80", "443", "8080", "22"]
  }
}