terraform {
  required_providers {
    aws = {
      version = "~> 2.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    region = var.region
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
