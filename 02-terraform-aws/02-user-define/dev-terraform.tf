data "aws_availability_zones" "available" { # 01. data rources block
  state = "available"
}

variable "os_type" {
  description = "machine type"
  type        = string
}

variable "instance_size" {
  description = "os type"
  type        = map(any)
  default = {
    "ubuntu18" = "ami-0135afc6d226a70a4"
    "ubuntu20" = "ami-04bad3c587fe60d89"
  }
}

locals {
  ami = lookup(var.instance_size, var.os_type) #02. lookup function
}

variable "dev-key-path" {
  description = "dev-public-key" 
  sensitive   = true

}
