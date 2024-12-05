provider "aws" {
    region = "us-east-1"
  
}

#VPC creation
resource "aws_vpc" "teravpc" {
    cidr_block = var.cidrange
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "Practice-vpc"
    }
}

#Public subnet 1
resource "aws_subnet" "publicone" {
    vpc_id = aws_vpc.teravpc.id
    cidr_block = var.cidrpubone
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
      Name = "Terapubone"
    }
}

#Public subnet 2
resource "aws_subnet" "publictwo" {
    vpc_id = aws_vpc.teravpc.id
    cidr_block = var.cidrpubone
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
    tags = {
        Name = "Terapubtwo"
    }
}

#Private subnet 1
resource "aws_subnet" "privatetone" {
    vpc_id = aws_vpc.teravpc.id
    cidr_block = var.cidrpubone
    availability_zone = "us-east-1c"
    tags = {
        Name = "Teraprione"
    }
}

#Private subnet 2
resource "aws_subnet" "privatetwo" {
    vpc_id = aws_vpc.teravpc.id
    cidr_block = var.cidrpubone
    availability_zone = "us-east-1d"
    tags = {
        Name = "Terapritwo"
    }
}

#Internet gateway creation
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.teravpc.id
    tags = {
      Name = "TeraIGW"
    }
}

#Route table creation for public
resource "aws_route_table" "RTpub" {
    vpc_id = aws_vpc.teravpc.id

    route {
        cidr_block = var.cidroute
        gateway_id = aws_internet_gateway.IGW.id
    }
}

#Subnet public association 1
resource "aws_route_table_association" "routeassoc1" {
    subnet_id = aws_subnet.publicone.id
    route_table_id = aws_route_table.RTpub.id
}

#Subnet public association 2
resource "aws_route_table_association" "routeassoc2" {
    subnet_id = aws_subnet.publictwo.id
    route_table_id = aws_route_table.RTpub.id
}

#Route table creation for private
resource "aws_route_table" "RTpri" {
    vpc_id = aws_vpc.teravpc.id

    route {
        cidr_block = var.cidrange
    }
}

#Subnet private association 1
resource "aws_route_table_association" "routeassoc3" {
    subnet_id = aws_subnet.privatetone.id
    route_table_id = aws_route_table.RTpri.id
}

#Subnet private association 2
resource "aws_route_table_association" "routeassoc4" {
    subnet_id = aws_subnet.privatetwo.id
    route_table_id = aws_route_table.RTpri.id
}

#security group creation
resource "aws_security_group" "SG" {
    name = "TeraSG1"
    vpc_id = aws_vpc.teravpc.id

    ingress {
        description = "this is SSH protcol"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }

    ingress {
        description = "this is HTTP protcol"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
         }

    egress {
        description = "this is all traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
         }
    tags = {
      Name = "TeraSG"
    }
}

output "vpc_id" {
    value = aws_vpc.teravpc.id
}

output "public_subnet_ids" {
    value = [aws_subnet.publicone.id, aws_subnet.publictwo.id]
    description = "Public subnet ids"
}

output "private_subnet_ids" {
    value = [aws_subnet.privatetone.id, aws_subnet.publictwo.id]
  
}

output "security_group_id" {
    value = aws_security_group.SG.id
}

