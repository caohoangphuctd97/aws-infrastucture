bucket = "aws-infrastructure-data"
region = "ap-southeast-1"

# VPC
cidr_block = "27.21.0.0/16"
enable_dns_support = "true"
enable_dns_hostnames = "true"
enable_classiclink = "false"
instance_tenancy = "default"

tags = {
    Name_project = "aws-infrastructure"
    Created_by = "PhucCao"
}

# Subnet 
cidr_public_subnet = "27.21.1.0/24"
availability_zone = "ap-southeast-1a"

# Key pair
PUBLIC_KEY_PATH = "asset/aws-infrastructure-key.pub"
PRIVATE_KEY_PATH = "asset/aws-infrastructure-key"
ec2_user = "ec2-user"

# Certificate IoT core
cert = "asset/phuccao.pem"