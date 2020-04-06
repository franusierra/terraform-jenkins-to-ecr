resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main"
  }
}
#Public subnets config
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.gw]
  availability_zone       = var.az[count.index]
  tags = {
    Name = "Public - ${var.az[count.index]}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}
resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

#Private subnets config
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.az[count.index]
  tags = {
    Name = "Private - ${var.az[count.index]}"
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_instance.id
  }

  tags = {
    Name = "private"
  }
}
resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
