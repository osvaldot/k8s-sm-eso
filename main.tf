module "tf_vpc" {
  source = "./vpc"
  cluster = var.cluster
  cidr_block = var.vpc_cidr_block
  azs = var.vpc_azs
  public_subnet_block = var.vpc_public_subnet_block
  private_subnet_block = var.vpc_private_subnet_block
}

module "tf_eks" {
  source = "./eks"
  cluster = var.cluster
  vpc_id = module.tf_vpc.vpc_id
  cidr_block = var.vpc_cidr_block
  subnets = module.tf_vpc.private_subnets
  admin_users = var.eks_admin_users
  dev_users = var.eks_dev_users
  node_instance_types = var.eks_node_instance_types
  node_desired = var.eks_node_desired
  node_min = var.eks_node_min
  node_max = var.eks_node_max
  project = var.project

  depends_on = [ module.tf_vpc ]
}

module "tf_sm" {
  source = "./secrets-manager"
  cluster = var.cluster
  project = var.project
  service_account_role = module.tf_eks.service_account_role

  depends_on = [module.tf_eks]
}

module "tf_eso" {
  source = "./eso"
  aws_default_region = var.aws_default_region
  service_account = module.tf_eks.service_account
  project = var.project

  depends_on = [module.tf_eks, module.tf_sm]
}

module "reloader" {
  source = "./stakater-reloader"
  project = var.project

  depends_on = [module.tf_eks, module.tf_sm, module.tf_eso]
}

### CUSTOM DATA SOURCES
data "aws_eks_cluster" "cluster" {
  name = module.tf_eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.tf_eks.cluster_id
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