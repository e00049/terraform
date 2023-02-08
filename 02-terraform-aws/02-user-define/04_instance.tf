resource "aws_key_pair" "dev-key-name" {
  key_name   = "e00049-workspace-machines"
  public_key = file(var.dev-key-path)
}

# Create EC2 Instance 
resource "aws_instance" "linux-webserver" {
  ami                    = local.ami
  instance_type          = local.instance_type
  subnet_id              = aws_subnet.dev-public-subnet.id
  key_name               = aws_key_pair.dev-key-name.key_name
  user_data              = file("user_data.sh") # 01. file function
  vpc_security_group_ids = [aws_security_group.dev-sg.id]

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp2"
    delete_on_termination = var.delete_on_termination
  }

  tags = {
    Name = "linux-webserver"
    env  = "dev"
  }
}
