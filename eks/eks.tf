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
      groups   = ["${var.cluster}-developers"]
    }
  ] 
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"

  cluster_name = var.cluster
  cluster_version  = "1.21"
  vpc_id  = var.vpc_id
  subnets = var.subnets
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  # Enable OIDC Provider
  enable_irsa = true
  write_kubeconfig = true

  node_groups = {
    core = {
      desired_capacity = var.node_desired
      min_capacity     = var.node_min
      max_capacity     = var.node_max

      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"
      subnets = var.subnets
      disk_size = 8     
    }
  }

  # map developer & admin ARNs as kubernetes Users
  map_users = concat(local.admin_user_map_users, local.developer_user_map_users)

  tags = {
    Cluster = var.cluster
  }
}

# Create Application namespace
resource "kubernetes_namespace" "namespace" {
  metadata {
    labels = {
      Cluster = var.cluster
    }
    name = var.project
  }
}

resource "aws_iam_role" "service_account" {
  name = "${var.cluster}-${var.project}-ServiceAccoutRole"
  assume_role_policy = templatefile(
    "${path.module}/files/iam-role.json",
    {
      oidc_provider_arn = module.eks.oidc_provider_arn
      cluster_oidc_issuer_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
      service_account_namespace = var.project
      service_account_name = "${var.project}-eso"
    }
  )

  tags = {
    Cluster = var.cluster
    Project = var.project
  }  
}

resource "kubectl_manifest" "service_account" {
  yaml_body = templatefile(
    "${path.module}/files/service-account.yaml",
    {
      namespace = var.project
      service_account_name = "${var.project}-eso"
      account_id = data.aws_caller_identity.current.account_id
      iam_role_name = aws_iam_role.service_account.name
    }
  )
}