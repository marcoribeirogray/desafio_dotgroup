data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-vpc"
      Environment = var.environment
    }
  )
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-igw"
      Environment = var.environment
    }
  )
}

resource "aws_subnet" "public_subnet" {
  for_each = { for index, cidr in var.public_subnets : index => cidr }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value
  availability_zone       = data.aws_availability_zones.available_zones.names[tonumber(each.key)]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-public-${each.key}"
      Environment = var.environment
    }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-public"
      Environment = var.environment
    }
  )
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_route_association" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

output "vpc_id" {
  description = "Identificador da VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  description = "Lista de IDs das sub-redes públicas"
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
}
