output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "vpn_gateway_id" {
  value = aws_vpn_gateway.this.id
}

output "default_security_group_id" {
  value = aws_default_security_group.this.id
}

output "subnets" {
  value = {
    public      = aws_subnet.public
    application = aws_subnet.application
    database    = aws_subnet.database
    eks         = aws_subnet.eks
  }
}
