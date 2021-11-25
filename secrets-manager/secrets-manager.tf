resource "aws_secretsmanager_secret" "secret" {
  for_each = toset(var.namespaces)

  name = each.key
  tags = {    
    Cluster = var.project
    Namespace = each.key
  }
}

resource "aws_iam_policy" "access_secrets" {
  for_each = toset(var.namespaces)

  name = "${each.key}-AccessSecrets"
  path = "/"

  policy = templatefile(
    "${path.module}/files/iam-policy.json",
    {
      aws_sm_secret_arn = aws_secretsmanager_secret.secret[each.key].arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "access_secrets" {
  for_each = var.service_accounts_role

  role = each.value
  policy_arn = aws_iam_policy.access_secrets[each.key].arn
}