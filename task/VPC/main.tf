resource "aws_vpc" "Myvpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "PublicSubnet" {
    vpc_id = aws_vpc.Myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true 
}
resource "aws_subnet" "PublicSubnet_2" {
    vpc_id = aws_vpc.Myvpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true 

}



resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.Myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false  
  tags = {
    Name = "private-subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.Myvpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false  
  tags = {
    Name = "private-subnet_2"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Myvpc.id
  tags = {
    Name = "internet_gw"
  }
}
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.Myvpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "PublicRTassoicate" { 
  subnet_id = aws_subnet.PublicSubnet.id 
  route_table_id = aws_route_table.publicRT.id
}
resource "aws_route_table_association" "PublicRTassoicate_2" {
  subnet_id = aws_subnet.PublicSubnet_2.id 
  route_table_id = aws_route_table.publicRT.id
}
resource "aws_eip" "eip" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.nat_subnet_id #subnet for nat gateway it's public subnt to allow internet access
  tags = {
    Name = "My-NAT"
  }
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.Myvpc.id
  route {
    cidr_block     = "0.0.0.0/0" #
    nat_gateway_id = aws_nat_gateway.nat.id #exit for the traffic 
  }
}
resource "aws_route_table_association" "Private_rta" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private-rt.id
  
}
resource "aws_route_table_association" "Private_rta2" {
  subnet_id = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_key_pair" "devloyper" {
    key_name = "aws_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqHUCSLsDUd/ykyKWEnXSp0Q1wHphcmbQwBgnpJty55ZbwVUO9Zx0z/XSQyu0Nun3A9BdCTsXtjKS7yd/deaG9yQ+Dvy7/zQbIxS9GD77JBMd4rNQmRYYAoXrEyrg4ksDzHei7rropOSEc0INgfEPVuw1JibmbaZF/Gr4cKqxYXAK+v6ihKHkCr4ZBN+sg8OkMGxsGa+ZKaHZTiyPzONa5UeeXJd3NTE3FxO0QRWiuZSJ1I8W9PasXdwnYH4YkbZIiPMY0aWGxkIdzXjZTv4RSOkThDCxcyJ2PjeI09w50AaNW41Ubwwcs3q4lXu/UMsBrkwP+/rASQrFDOUtHUwCf emad@DESKTOP-M7NGHGA"
  
}
resource "aws_security_group" "sg_8080" {
  vpc_id = aws_vpc.Myvpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow custom port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = "sg_8080"
}

