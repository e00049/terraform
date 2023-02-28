 # https://developer.hashicorp.com/terraform/tutorials/configuration-language/troubleshooting-workflow#format-the-configuration

resource "aws_instance" "web_app" {
#   for_each               = aws_security_group.*.id
   for_each               = local.security_groups
   ami                    = data.aws_ami.ubuntu.id
   instance_type          = "t2.micro"
#   vpc_security_group_ids = [each.id]
   vpc_security_group_ids = [each.value]
   user_data              = <<-EOF
               #!/bin/bash
               apt-get update
               apt-get install -y apache2
               sed -i -e 's/80/8080/' /etc/apache2/ports.conf
               echo "Hello World" > /var/www/html/index.html
               systemctl restart apache2
               EOF
   tags = {
#   Name = "${var.name}-learn"
+   Name = "${var.name}-learn-${each.key}"
   }
 }
}


locals {
  security_groups = {
    sg_ping   = aws_security_group.sg_ping.id,
    sg_8080   = aws_security_group.sg_8080.id,
  }
}

 output "instance_id" {
   description = "ID of the EC2 instance"
-   value       = aws_instance.web_app.id
+   value       = [for instance in aws_instance.web_app: instance.id]
 }
    

 output "instance_public_ip" {
   description = "Public IP address of the EC2 instance"
-   value       = aws_instance.web_app.public_ip
+   value       = [for instance in aws_instance.web_app: instance.public_ip]
 }

output "instance_name" {
   description = "Tags of the EC2 instance"
-  value        = aws_instance.web_app.tags
+  value        = [for instance in aws_instance.web_app: instance.tags.Name]
}

   
   
