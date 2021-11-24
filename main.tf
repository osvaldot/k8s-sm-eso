module "vpc" {
  source = "./vpc"
  project = var.project
  cidr_block = var.vpc_cidr_block
  azs = var.vpc_azs
  public_subnet_block = var.vpc_public_subnet_block
  private_subnet_block = var.vpc_private_subnet_block
}
