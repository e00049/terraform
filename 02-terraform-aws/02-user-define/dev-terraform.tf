data "aws_availability_zones" "available" { # 01. data rources block
  state = "available"
}

variable "dev-key-path" {
  description = "dev-public-key"
  sensitive   = true
}

variable "os_type" {
  description = "os from user type"
  type        = string
}

variable "ami_type" {
  description = "os type"
  type        = map(any)
  default = {
    "ubuntu18" = "ami-0135afc6d226a70a4"
    "ubuntu20" = "ami-04bad3c587fe60d89"
  }
}

locals {
  ami = lookup(var.ami_type, var.os_type) # 02. lookup function
}

variable "server_type" {
  description = "machine from user type"
  type        = string
}

variable "instance_type" {
  description = "machin type"
  type        = map(any)
  default = {
    "t2" = "t2.micro"
    "t3" = "t3.medium"
  }
}

locals {
  instance_type = lookup(var.instance_type, var.server_type) # 02. lookup function
}

variable "volume_size" {
  description = "volume type"
  type        = number
}

variable "delete_on_termination" {
  description = "delete_on_termination"
  type        = bool
}
