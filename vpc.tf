resource "aws_vpc" "custom-vpc-01" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "custom-igw-01" {
  vpc_id = aws_vpc.custom-vpc-01.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_default_route_table" "custom-vpc-default-route-table" {
  default_route_table_id = aws_vpc.custom-vpc-01.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom-igw-01.id
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.custom-vpc-01.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

resource "aws_eip" "nat_gw_elastic-ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "custom-nat-gw-01" {
  allocation_id     = aws_eip.nat_gw_elastic-ip.id
  subnet_id         = aws_subnet.public_subnet["public_subnet_01"].id
  connectivity_type = "public"
  depends_on        = [aws_internet_gateway.custom-igw-01]
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.custom-vpc-01.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom-nat-gw-01.id
  }

  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.custom-vpc-01.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = each.key
  }
}

locals {
  private_subnet_id = ["${aws_subnet.private_subnet["private_subnet_01"].id}", "${aws_subnet.private_subnet["private_subnet_02"].id}"]
}

resource "aws_route_table_association" "private-route-table-aws_route_table_association" {
  count          = length(local.private_subnet_id)
  subnet_id      = local.private_subnet_id[count.index]
  route_table_id = aws_route_table.private-route-table.id
}