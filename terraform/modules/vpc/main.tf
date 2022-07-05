resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = var.enable_dns_hostnames
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_vpn_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
