#!/usr/bin/env bash 

sudo useradd -s /bin/bash -d /home/e00049 -m -G sudo e00049
sudo echo -e "e00049\e00049" | passwd e00049 > /dev/null 2>&1
echo "e00049 ALL=(ALL)      NOPASSWD: ALL" >> /etc/sudoers
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin forced-commands-only/#PermitRootLogin forced-commands-only/g' /etc/ssh/sshd_config
systemctl restart sshd >/dev/null 2>&1

sudo apt update 
sudo apt install apache2 -y

