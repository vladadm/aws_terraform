output "develop_vpc" {
  value = aws_vpc.develop_vpc.id
}

output "develop_vpc_cidr" {
  value = aws_vpc.develop_vpc.cidr_block
}

output "develop_subnet_cidr" {
  value = aws_subnet.develop_subnet.cidr_block
}

output "develop_subnet_zone" {
  value = aws_subnet.develop_subnet.availability_zone
}

output "production_vpc" {
  value = aws_vpc.production_vpc.id
}

output "production_vpc_cidr" {
  value = aws_vpc.production_vpc.cidr_block
}

output "production_subnet_cidr" {
  value = aws_subnet.production_subnet.cidr_block
}

output "production_subnet_zone" {
  value = aws_subnet.production_subnet.availability_zone
}
