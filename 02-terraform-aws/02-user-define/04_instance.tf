# Create EC2 Instance 
resource "aws_instance" "webserver" {
  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dev-public-subnet.id
  key_name               = "e00049-workspace-machine"
  user_data              = file("user_data.sh")
  vpc_security_group_ids = [aws_security_group.dev-sg.id]

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "linux-webserver"
    env  = "dev"
  }
}