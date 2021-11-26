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
  for_each = toset(var.namespaces)

  name       = "reloader-${each.key}"
  chart      = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  namespace  = each.key
  # version    = "v0.0.103"

  set {
    name = "reloader.watchGlobally"
    value =false
  }
}