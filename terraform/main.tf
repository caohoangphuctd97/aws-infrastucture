terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "permission" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = true
  block_public_policy = true
}


resource "aws_vpc" "prod-vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = var.enable_dns_support #gives you an internal domain name
  enable_dns_hostnames = var.enable_dns_hostnames #gives you an internal host name
  enable_classiclink = var.enable_classiclink
  instance_tenancy = var.instance_tenancy    
  tags = merge({"Name": "aws-infrastructure-vpc"},var.tags)
}

resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = var.cidr_public_subnet
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = var.availability_zone
  tags = merge({"Name": "aws-infrastructure-public-subnet"},var.tags)
}

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = merge({"Name": "aws-infrastructure-gateway"},var.tags)
}

resource "aws_route_table" "prod-public-crt" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.prod-igw.id}" 
    }
    
    tags = merge({"Name": "aws-infrastructure-RT"},var.tags)
}

resource "aws_route_table_association" "prod-crta-public-subnet-1"{
  subnet_id = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.prod-public-crt.id
}

resource "aws_security_group" "security_group" {
    vpc_id = aws_vpc.prod-vpc.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge({"Name": "aws-infrastructure-sg"},var.tags)
}

resource "aws_instance" "web1" {
    ami = "ami-0e5182fad1edfaa68"
    instance_type = "t2.micro"
    # Subnet public
    subnet_id = aws_subnet.prod-subnet-public-1.id
    # Security Group
    vpc_security_group_ids = [aws_security_group.security_group.id]
    # the Public SSH key
    key_name = aws_key_pair.key-pair.id
    # nginx installation
    provisioner "file" {
      source = "./source/nginx.sh"
      destination = "/home/${var.ec2_user}/nginx.sh"
    }
    provisioner "remote-exec" {
      inline = [
        "chmod +x /home/${var.ec2_user}/nginx.sh",
        "sudo sh /home/${var.ec2_user}/nginx.sh"
      ]
    }
    connection {
      host = self.public_ip
      user = var.ec2_user
      private_key = file("./${var.PRIVATE_KEY_PATH}")
    }
    tags = merge({"Name": "aws-infrastructure-ec2"},var.tags)
}

resource "aws_key_pair" "key-pair" {
  key_name = "aws-infrastructure-key"
  
  public_key = file(var.PUBLIC_KEY_PATH)
}

# IoT Core
resource "aws_iot_thing" "example" {
  name = "demoIoT"
}

resource "aws_iot_certificate" "cert" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "att" {
  principal = aws_iot_certificate.cert.arn
  thing     = aws_iot_thing.example.name
}