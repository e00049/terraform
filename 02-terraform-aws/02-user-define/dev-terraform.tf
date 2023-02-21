variable "dev-key-path" {
  description = "dev-public-key"
  sensitive   = true
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

locals {
  subnets = [aws_subnet.dev-public-subnet-01.id, aws_subnet.dev-public-subnet-02.id] # Cross reference
}

variable "volume_size" {
  description = "volume type"
  type        = number
}

variable "delete_on_termination" {
  description = "delete_on_termination"
  type        = bool
}

variable "db_username" {
  description = "db username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "db password"
  type        = string
  sensitive   = true
}

variable "initial_db_name" {
  description = "initial db name"
  type        = string
  sensitive   = true
}

variable "instance_tag" {
  type = list(any)
}