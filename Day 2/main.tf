resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block
    tags = {
        Name = "My_VPC_Tf"
    }
}

resource "aws_subnet" "private_sub" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = var.region1
    map_public_ip_on_launch = true
}

resource "aws_subnet" "public_sub" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = var.region2
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "RT1" {
    subnet_id = aws_subnet.private_sub.id
    route_table_id = aws_route_table.RT.id
    gateway_id = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "RT2" {
    route_table_id = aws_route_table.RT.id
    subnet_id = aws_subnet.public_sub.id
}

resource "aws_security_group" "my_SG" {
    name = "TF_SG"
    description = "SG created using TF"
    vpc_id = aws_vpc.my_vpc.id
        ingress {
            description = "HTTP"
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
            description = "SSH"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
            description = "RDP"
            from_port = 3389
            to_port = 3389
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    tags = {
        Name = "My_SG_TF"
    }
}

resource "aws_instance" "linux_server" {
    ami = var.ami_linux
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.my_SG.id]
    subnet_id = aws_subnet.public_sub.id
    tags = {
      Name = "Linux_server"
    }
}

resource "aws_instance" "windows_server" {
    ami = var.ami_windows
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.my_SG.id]
    subnet_id = aws_subnet.private_sub.id
    tags = {
      Name = "Windows_server"
    }
}