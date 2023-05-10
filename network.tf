# Create VPC

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "tfe-aa-vpc"
  }
}

# Create subnets, 2 public and 2 private

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "eu-central-1b"
  tags = {
    Name = "tfe-aa-public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "eu-central-1c"

  tags = {
    Name = "tfe-aa-public2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.11.0/24"
  availability_zone = "eu-central-1b"
  tags = {
    Name = "tfe-aa-private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.12.0/24"
  availability_zone = "eu-central-1c"
  tags = {
    Name = "tfe-aa-private2"
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tfe-aa-igw"
  }
}

# Create Route Tables
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "tfe-aa-route-table-gw"
  }
}

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "tfe-aa-route-table-nat"
  }
}

# Create Elastic IP

resource "aws_eip" "eip" {
  vpc = true
  
  tags = {
    Name = "tfe-aa-eip"
  }
}

# Create NAT Gateway 

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "tfe-aa-nat"
  }
}

# Associate Subnets with Route Tables
resource "aws_route_table_association" "PublicRT1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "PublicRT2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "PrivateRT1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.privatert.id
}

resource "aws_route_table_association" "PrivateRT2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.privatert.id
}