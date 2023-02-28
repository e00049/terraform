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
