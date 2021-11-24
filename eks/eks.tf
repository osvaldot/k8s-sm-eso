data "aws_caller_identity" "current" {}

locals {
  admin_user_map_users = [
    for admin_user in var.admin_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${admin_user}"
      username = admin_user
      groups   = ["system:masters"]
    }
  ]

  developer_user_map_users = [
    for developer_user in var.dev_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${developer_user}"
      username = developer_user
      groups   = ["${var.project}-developers"]
    }
  ] 
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"

  cluster_name = var.project
  cluster_version  = "1.21"
  vpc_id  = var.vpc_id
  subnets = var.subnets
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  # Enable OIDC Provider
  enable_irsa = true
  write_kubeconfig = false

  node_groups = {
    core = {
      desired_capacity = var.node_desired
      min_capacity     = var.node_min
      max_capacity     = var.node_max
      create_launch_template = true
      disk_type = "gp3"

      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"
      subnets = var.subnets
      disk_size = 8     
    }
  }

  # map developer & admin ARNs as kubernetes Users
  map_users = concat(local.admin_user_map_users, local.developer_user_map_users)

  tags = {
    Cluster = var.project
  }
}

# Create Application namespaces
resource "kubernetes_namespace" "cluster_namespaces" {
for_each = toset(var.namespaces)

  metadata {
    labels = {
      Cluster = var.project
    }

    name = each.key
  }
}

resource "helm_release" "external-secrets" {
  name       = "external-secrets"
  chart      = "external-secrets"
  repository = "https://charts.external-secrets.io"
  namespace  = "external-secrets"
  create_namespace = true
}