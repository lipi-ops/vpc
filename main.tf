provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "this" {
  cidr_block = "10.${var.environment == "dev" ? 1 : 2}.0.0/16"
  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "subnets" {
  count             = var.instance_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.${var.environment == "dev" ? 1 : 2}.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  tags = {
    Name = "${var.environment}-subnet-${count.index}"
  }
}

resource "aws_instance" "instances" {
  count           = var.instance_count
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.subnets[count.index].id
  key_name        = var.key_name
  tags = {
    Name = "${var.environment}-ec2-${count.index}"
  }
}

data "aws_availability_zones" "available" {}
