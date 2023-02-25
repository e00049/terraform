# Create Security Group for SSH and HTTP 
resource "aws_security_group" "dev-sg" {
  name        = "dev-sg"
  description = "allow all traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dev-sg"
    env  = "dev"
  }
}

/*
  dynamic "ingress" {
    for_each = ["8000", "9000", "7000", "1000"]
    content {
      description = "Allow port UDP"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
*/
  
