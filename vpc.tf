resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main"
    owner = var.owner
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
    owner = var.owner
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
    owner = var.owner
  }
}
resource "aws_subnet" "databases" {
  count             = length(var.databases_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.databases_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "databases-${count.index + 1}"
    owner = var.owner
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet-gateway"
    owner = var.owner
  }
}
resource "aws_eip" "nat-eip" {
  vpc = true
  tags = {
    owner = var.owner
  }
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "main-nat"
    owner = var.owner
  }
}


resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.my_cidr
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "main-public"
    owner = var.owner
  }
}

resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.my_cidr
    gateway_id = aws_nat_gateway.main-natgw.id
  }
  tags = {
    Name = "main-private"
    owner = var.owner
  }
}
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = aws_route_table.main-private.id
}

#-------------------Bastion
resource "aws_network_interface" "bastion" {
  subnet_id       = aws_subnet.public.0.id
  security_groups =  [aws_security_group.allow_ssh.id]
  tags = {
    Name = "network-interface-bastion"
    owner = var.owner
  }
}
