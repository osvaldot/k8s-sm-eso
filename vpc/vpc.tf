module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name = "${var.project}-vpc"
  cidr = var.cidr_block
  azs = var.azs
  private_subnets = var.private_subnet_block
  public_subnets = var.public_subnet_block
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.project}" = "shared"
    Cluster = var.project
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.project}" = "shared"
    "kubernetes.io/role/elb" = "1"
    Cluster = var.project
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.project}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
    Cluster = var.project
  }
}
