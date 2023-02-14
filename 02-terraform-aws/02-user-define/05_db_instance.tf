resource "aws_db_subnet_group" "dev-subnet-group" {
  name       = "dev-subnet-group"
  subnet_ids = [aws_subnet.dev-public-subnet-01.id, aws_subnet.dev-public-subnet-02.id]
  tags = {
    Name = "dev-subnet-group"
    env  = "dev"
  }
}

resource "aws_db_instance" "dev_database" {
  engine                 = "mysql"
  identifier             = "dev-rds-mysql"
  username               = var.db_username
  password               = var.db_password
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.dev-subnet-group.id
  vpc_security_group_ids = [aws_security_group.dev-sg.id]
  skip_final_snapshot    = true
  availability_zone      = "us-west-2a"
  db_name                = var.initial_db_name
}