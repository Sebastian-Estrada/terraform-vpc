resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = var.public
  availability_zone       = var.availability_zone
  tags = {
    Name = var.name
  }
}