# PROVIDERS

provider "aws" {
  alias = "default"
  region = var.aws_default_region
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      version = "~> 2.0"
    }
    helm = {
      version = "~> 2.0"
    }
  }
}