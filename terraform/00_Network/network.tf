# --------------------------
#
# Network objects
# 1. VPC
# 2. Subnets
# 3. Internet Gateway
# 4. Route Tables
#
#
# --------------------------

variable "vps_cidr" {
  default = [
    "172.31.0.0/16",
    "172.41.0.0/16",
  ]
}

variable "subnet_cidr" {
  default = [
    "172.41.1.0/24",
    "172.41.2.0/24",
  ]
}

resource "aws_vpc" "dev_vpc" {
  name = "develop"

  tags {
    Name = "develop"

  }
}

resource "aws_subnet" "dev_subnet" {

}

resource "aws_network_acl" "dev_acl" {

}

resource "aws_internet_gateway" "dev_iag" {
  vpc = aws_vpc.dev_vpc.id

  tags {
    Name = "develop"
  }
}

resource "aws_route_table" "dev_net_rt" {

}
