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

