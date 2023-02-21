# os_type               = "ubuntu18" # 01. string 
server_type           = "t2"
dev-key-path          = "/home/e00049/.ssh/id_rsa.pub" # 01 file function
volume_size           = 8                              # 02 number
delete_on_termination = true                           # 03 bool
db_username           = "e00049"
db_password           = "e00049123"
initial_db_name       = "terraform"

instance_tag = [{
  Name = "tf-webserver1"
  env  = "dev"
  },
  {
    Name = "tf-webserver2"
    env  = "dev"
}]