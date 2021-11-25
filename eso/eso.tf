resource "helm_release" "external-secrets" {
  name       = "external-secrets"
  chart      = "external-secrets"
  repository = "https://charts.external-secrets.io"
  namespace  = "external-secrets"
  create_namespace = true
}

resource "kubectl_manifest" "secret_store" {
  for_each = var.service_accounts

  yaml_body = templatefile(
    "${path.module}/files/secret-store.yaml",
    {
      namespace = each.key
      aws_region = var.aws_default_region
      service_account_name = each.value
    }
  )
}

resource "kubectl_manifest" "external_secret" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/files/external-secret.yaml",
    {
      namespace = each.key      
    }
  )
}