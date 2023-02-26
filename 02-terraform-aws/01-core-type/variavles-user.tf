#----------------------------------------------------------
#  Terraform - From Zero to Certified Professional
#
# Use Variables and Multiply files
#
# Made by Denis Astahov
#----------------------------------------------------------
provider "aws" {
  region = var.aws_region
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

resource "aws_eip" "web" {
  vpc      = true # Need to be added in new versions of AWS Provider
  instance = aws_instance.web.id
  tags     = merge(var.tags, { Name = "${var.tags["Environment"]}-EIP for WebServer Built by Terraform" })
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_size
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_pair
  user_data              = file("user_data.sh")
  tags                   = merge(var.tags, { Name = "${var.tags["Environment"]}-WebServer Built by Terraform" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web" {
  name        = "${var.tags["Environment"]}-WebServer-SG"
  description = "Security Group for my ${var.tags["Environment"]} WebServer"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = var.port_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.tags["Environment"]}-WebServer SG by Terraform" })
}

# -------------------------------------------------------------

output "public_ip" {
  value = aws_eip.web.public_ip
}

output "server_id" {
  value = aws_instance.web.id
}

output "securitygroup_id" {
  value = aws_security_group.web.id
}

# ----------------------------------------------------------------

/* 
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`


cat <<EOF > /var/www/html/index.html
<html>
<h2>Built by Power of <font color="red">Terraform</font></h2><br>

WebServer with Static IP! <br>

<br>
PrivateIP: $MYIP

<p>
<font color="blue">Version 4.0</font>
</html>
EOF

service httpd start
chkconfig httpd on

*/

# -----------------------------------------------------------------



variable "aws_region" {
  description = "Region where you want to provision this EC2 WebServer"
  type        = string // number , bool
  default     = "ca-central-1"
}

variable "port_list" {
  description = "List of Poret to open for our WebServer"
  type        = list(any)
  default     = ["80", "443"]
}

variable "instance_size" {
  description = "EC2 Instance Size to provision"
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "Tags to Apply to Resources"
  type        = map(any)
  default = {
    Owner       = "Denis Astahov"
    Environment = "Prod"
    Project     = "Phoenix"
  }
}

variable "key_pair" {
  description = "SSH Key pair name to ingest into EC2"
  type        = string
  default     = "CanadaKey"
  sensitive   = true
}

variable "password" {
  description = "Please Enter Password lenght of 10 characters!"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.password) == 10
    error_message = "Your Password must be 10 characted exactly!!!"
  }
}

# ----------------------------------------------------------------------------------

# terraform apply -tar-file=prod.auto.tfvars