resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  # 7 new bits mean 128 subnets (should be enough as regions have maximum 6 AZs).
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 7, count.index)

  map_public_ip_on_launch = true

  tags = merge({
    Name = "public-${count.index}"
  }, { for c in var.eks_clusters : "kubernetes.io/cluster/${c}" => "shared" })
}

resource "aws_subnet" "application" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  # 6 new bits mean 64 subnets (should be enough as regions have maximum 6 AZs).
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 6, 3 + count.index)

  tags = {
    Name = "application-${count.index}"
  }
}

resource "aws_subnet" "database" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  # 7 new bits mean 128 subnets (should be enough as regions have maximum 6 AZs).
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 7, 3 + count.index)

  tags = {
    Name = "database-${count.index}"
  }
}

resource "aws_subnet" "eks" {
  count = length(var.eks_clusters) > 0 ? length(data.aws_availability_zones.available.names) : 0

  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  # 5 new bits mean 32 subnets (should be enough as regions have maximum 6 AZs).
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 5, 3 + count.index)

  tags = merge({
    Name = "eks-${count.index}"
  }, { for c in var.eks_clusters : "kubernetes.io/cluster/${c}" => "shared" })
}
