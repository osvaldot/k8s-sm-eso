terraform {
  required_version = "~> 1.0"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.11.3"
    }
    kubernetes = {
      version = "~> 2.0"
    }
    helm = {
      version = "~> 2.0"
    }
  }
}