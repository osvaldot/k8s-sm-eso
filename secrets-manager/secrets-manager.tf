resource "aws_secretsmanager_secret" "secret" {
  name = var.project
  recovery_window_in_days = 0

  tags = {    
    Cluster = var.cluster
    Project = var.project
  }
}

resource "aws_iam_policy" "access_secrets" {
  name = "${var.project}-AccessSecrets"
  path = "/"

  policy = templatefile(
    "${path.module}/files/iam-policy.json",
    {
      aws_sm_secret_arn = aws_secretsmanager_secret.secret.arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "access_secrets" {
  role = var.service_account_role
  policy_arn = aws_iam_policy.access_secrets.arn
}