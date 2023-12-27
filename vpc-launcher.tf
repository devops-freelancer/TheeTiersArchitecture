# Create VPC

resource "aws_vpc" "main-vpc" {
  cidr_block              = var.main-cidr-block
  enable_dns_hostnames    = true
  tags      = {
    Name    = var.vpc-name
  }
}

# Create Public Subnets

resource "aws_subnet" "public-subnet" {
  count                   = length(var.availability-zone)
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public-cidr-block[count.index]
  availability_zone       = element(var.availability-zone, count.index)
  map_public_ip_on_launch = true

  tags      = {
   Name = "PublicSubnet-${count.index + 1}"
    Tier =  "Public"
  }
}


# Create Private Subnets

resource "aws_subnet" "private-subnet" {
  count = length(var.private-cidr-block)
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.private-cidr-block[count.index]
  availability_zone       = element(var.availability-zone, count.index)
  map_public_ip_on_launch = false

  tags      = {
   Name = "PrivateSubnet-${count.index + 1}"
   Tier =  "Private"
  }
}

# Create Internet Gateway and Attach it to VPC

resource "aws_internet_gateway" "main-vpc-igw-01" {
  vpc_id    = aws_vpc.main-vpc.id

  tags      = {
    Name    = "Main-VPC-IGW"
  }
}


# Create Route Table and Add Public Route

resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-vpc-igw-01.id
  }
  tags       = {
    Name     = "Public-Route-Table"
  }

}

resource "aws_eip" "nat-gw-eip" {
  domain   = "vpc"
  tags   = {
    Name = "NAT-GW-EIP"
  }
}

resource "aws_nat_gateway" "natnw" {
  count      = 1
  subnet_id  = aws_subnet.public-subnet[count.index].id
  allocation_id = aws_eip.nat-gw-eip.id
  tags = {
    Name = "NAT-GTW-${count.index + 1}"
  }
}

#  resource "aws_route_table" "private-route-table" {
#  count = length(aws_subnet.public-subnet)
#  gateway_id = aws_nat_gateway.natnw[0].id
#    }
#  
#  tags = {
#    
#    Name     = "Private-Route-Table"
#  }
#}

