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

data "aws_ami_ids" "amazon_linux_2" {
  owners = ["amazon"]

  filter {
    name   = "image-id"
    values = ["ami-0e5182fad1edfaa68"]
  }
}

