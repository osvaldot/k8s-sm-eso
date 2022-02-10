resource "helm_release" "external-secrets" {
  name       = "external-secrets"
  chart      = "external-secrets"
  repository = "https://charts.external-secrets.io"
  namespace  = "external-secrets"
  create_namespace = true
  version    = "0.3.11"
}

resource "kubectl_manifest" "secret_store" {
  yaml_body = templatefile(
    "${path.module}/files/secret-store.yaml",
    {
      namespace = var.service_accounts
      aws_region = var.aws_default_region
      service_account_name = var.service_accounts
    }
  )

  depends_on = [helm_release.external-secrets]
}

resource "kubectl_manifest" "external_secret" {
  yaml_body = templatefile(
    "${path.module}/files/external-secret.yaml",
    {
      namespace = var.service_accounts      
    }
  )
  depends_on = [kubectl_manifest.secret_store]
}