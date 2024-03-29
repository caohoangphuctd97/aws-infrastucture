#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install nginx
sudo yum -y update
sudo amazon-linux-extras install -y nginx1

# make sure nginx is started
sudo systemctl start nginx.service
sudo systemctl status nginx.service