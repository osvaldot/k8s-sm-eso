output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "service_accounts_role" {
  value = tomap({
    for k, inst in aws_iam_role.service_account : k => inst.name
  })  
}

output "service_accounts" {
  value = tomap({
    for k, inst in kubectl_manifest.service_account : k => inst.name
  })    
}