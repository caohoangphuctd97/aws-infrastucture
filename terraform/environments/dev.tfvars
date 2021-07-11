bucket = "aws-infrastructure-data"
region = "ap-southeast-1"

# VPC
cidr_block = "27.21.0.0/16"
enable_dns_support = "true"
enable_dns_hostnames = "true"
enable_classiclink = "false"
instance_tenancy = "default"

tags = {
    Name = "aws-infrastructure-vpc"
    Created_by = "PhucCao"
}

# Subnet 
cidr_public_subnet = "27.21.1.0/24"