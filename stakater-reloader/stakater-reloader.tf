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

resource "helm_release" "reloader" {
  name       = "reloader-${var.namespaces}"
  chart      = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  namespace  = var.namespaces
  version    = "v0.0.103"

  set {
    name  = "reloader.watchGlobally"
    value = false
  }
}