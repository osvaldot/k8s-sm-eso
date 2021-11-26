module "vpc" {
  source = "./vpc"
  project = var.project
  cidr_block = var.vpc_cidr_block
  azs = var.vpc_azs
  public_subnet_block = var.vpc_public_subnet_block
  private_subnet_block = var.vpc_private_subnet_block
}

module "eks" {
  source = "./eks"
  project = var.project
  vpc_id = module.vpc.vpc_id
  cidr_block = var.vpc_cidr_block
  subnets = module.vpc.private_subnets
  admin_users = var.eks_admin_users
  dev_users = var.eks_dev_users
  node_instance_types = var.eks_node_instance_types
  node_desired = var.eks_node_desired
  node_min = var.eks_node_min
  node_max = var.eks_node_max
  namespaces = var.namespaces

  depends_on = [ module.vpc ]
}

module "sm" {
  source = "./secrets-manager"
  project = var.project
  namespaces = var.namespaces
  service_accounts_role = module.eks.service_accounts_role

  depends_on = [module.eks]
}


module "eso" {
  source = "./eso"
  aws_default_region = var.aws_default_region
  service_accounts = module.eks.service_accounts
  namespaces = var.namespaces

  depends_on = [module.eks, module.sm]
}

module "reloader" {
  source = "./stakater-reloader"
  namespaces = var.namespaces

  depends_on = [module.eks, module.sm, module.eso]
}

### CUSTOM DATA SOURCES
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

### PROVIDERS
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubectl" {
  load_config_file = false
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
}