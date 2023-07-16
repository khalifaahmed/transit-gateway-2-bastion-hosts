#!/usr/bin/bash
sudo apt update
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo echo "<h1>HostName = $(hostname -f) </h1>" > /var/www/html/index.html