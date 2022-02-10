resource "aws_secretsmanager_secret" "secret" {
  name = var.namespaces
  recovery_window_in_days = 0

  tags = {    
    Cluster = var.project
    Namespace = var.namespaces
  }
}

resource "aws_iam_policy" "access_secrets" {
  name = "${var.namespaces}-AccessSecrets"
  path = "/"

  policy = templatefile(
    "${path.module}/files/iam-policy.json",
    {
      aws_sm_secret_arn = aws_secretsmanager_secret.secret.arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "access_secrets" {
  role = var.service_accounts_role
  policy_arn = aws_iam_policy.access_secrets.arn
}