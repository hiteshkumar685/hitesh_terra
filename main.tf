provider "aws" {
  region = "ap-south-1" # Change this to your desired AWS region
}

#VPC
resource "aws_vpc" "Hitesh" {
  cidr_block = "172.31.0.0/16"
  
  
}
resource "aws_subnet" "Hitesh_sub" {
  vpc_id = aws_vpc.Hitesh.id
  cidr_block = "172.31.49.0/24"
  
  
}
resource "aws_security_group" "hitesh_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.Hitesh.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.kp.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
}
  



# # Retrieve a subnet ID from the specified VPC
# data "aws_subnet" "selected_subnet" {
#   vpc_id = aws_vpc.Hitesh.id
# }

resource "aws_instance" "hit_inst" {
  tags = {
    Name=var.ins_name
  }
  
  ami = "ami-0a7cf821b91bcccbc"
  instance_type = "t2.micro"  # Replace with your desired instance type
  # subnet_id     = data.aws_subnet.selected_subnet.ids[0]  # Choose the first subnet ID from the list
  key_name = aws_key_pair.kp.key_name
}

