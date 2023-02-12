resource "aws_key_pair" "dev-key-name" {
  key_name   = "e00049-workspace-machines"
  public_key = file(var.dev-key-path)
}

data "aws_ami" "updated_ami" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.*-x86_64-gp2"]
  }
}

# Create EC2 Instance 
resource "aws_instance" "linux-webserver" {
  ami                    = data.aws_ami.updated_ami.id
  instance_type          = local.instance_type
  subnet_id              = aws_subnet.dev-public-subnet-01.id
  key_name               = aws_key_pair.dev-key-name.key_name
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

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > public_ip.txt"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("/home/e00049/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install php8.0 mariadb10.5 -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo mkdir /var/www/inc",
      "sudo chown -R ec2-user /var/www/"
    ]
  }
  provisioner "file" {
    content     = <<-EOF
        <?php
        define('DB_SERVER',   '${aws_db_instance.dev_database.address}');
        define('DB_USERNAME', '${var.db_username}');
        define('DB_PASSWORD', '${var.db_password}');
        define('DB_DATABASE', '${var.initial_db_name}');
        ?>
      EOF
    destination = "/var/www/inc/dbinfo.inc"
  }

  provisioner "file" {
    source      = "./temp/index.php"
    destination = "/var/www/html/index.php"
  }
}
