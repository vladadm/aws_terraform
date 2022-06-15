#
# MAINTAINER Vladislav Eldyshev "vladislav.adm@gmail.com"
#
# --------------------------
#
# Network objects
# 1. VPC
# 2. Subnets
# 3. Internet Gateway
# 4. Route Tables
# 5. Security Groups (May be)
#
# --------------------------


resource "aws_vpc" "develop_vpc" {
  cidr_block           = var.develop_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "develop_vpc"
    env  = "develop"
  }
}

resource "aws_vpc" "production_vpc" {
  cidr_block           = var.production_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "production_vpc"
    env  = "production"
  }
}

resource "aws_subnet" "develop_subnet" {
  cidr_block              = var.develop_subnet_cidr
  vpc_id                  = aws_vpc.develop_vpc.id
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "develop_subnet"
    env  = "develop"
  }
}

resource "aws_subnet" "production_subnet" {
  cidr_block              = var.production_subnet_cidr
  vpc_id                  = aws_vpc.production_vpc.id
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1b"
  tags = {
    Name = "production_subnet"
    env  = "production"
  }
}

resource "aws_internet_gateway" "develop_internet_gateway" {
  vpc_id = aws_vpc.develop_vpc.id
  tags = {
    Name = "develop_internet_gateway"
  }
}

resource "aws_internet_gateway" "production_internet_gateway" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "production_internet_gateway"
  }
}
