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

resource "aws_s3_bucket" "b" {
  bucket = var.bucket
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
