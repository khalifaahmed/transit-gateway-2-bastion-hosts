resource "aws_vpc" "main" {
  cidr_block = var.main_vpc_cidr

  #Enable dns 
  enable_dns_hostnames = true
  enable_dns_support   = true
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_igw"
  }
}

resource "aws_subnet" "main_public" {
  count                   = local.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.main_public_cidrs[count.index]            #cidr_block = [for i in range(1, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)][count.index]
  availability_zone       = random_shuffle.az_list.result[count.index] #availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "main_public_${count.index + 1}"
  }
}

resource "aws_subnet" "main_private" {
  count                   = local.private_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.main_private_cidrs[count.index]           #cidr_block = [for i in range(2, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)][count.index]
  availability_zone       = random_shuffle.az_list.result[count.index] #availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "main_private_${count.index + 1}"
  }
}

resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_public_RT"
  }
}

resource "aws_route_table" "main_private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_private_RT"
  }
}

resource "aws_route" "main_public" {
  route_table_id         = aws_route_table.main_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_gw.id
}

resource "aws_route_table_association" "main_public" {
  count          = local.public_subnet_count
  subnet_id      = aws_subnet.main_public.*.id[count.index]
  route_table_id = aws_route_table.main_public.id
}

resource "aws_route_table_association" "main_private" {
  count          = local.private_subnet_count
  subnet_id      = aws_subnet.main_private.*.id[count.index]
  route_table_id = aws_route_table.main_private.id
}


resource "aws_security_group" "main" {
  name        = "main_public"
  description = "Allow all inbound traffic anywhere"
  vpc_id      = aws_vpc.main.id

  ingress { #inbound
    description      = "inbound all traffic anywhere"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.access_ip_v4]
    ipv6_cidr_blocks = [var.access_ip_v6]
  }
  egress { #outbound
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "main_public"
  }
}


