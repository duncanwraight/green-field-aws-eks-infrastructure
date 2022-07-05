resource "aws_eks_cluster" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_cluster_policy,
    aws_iam_role_policy_attachment.eks_cluster_service_policy,
    aws_cloudwatch_log_group.this
  ]

  name                      = var.name
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  version                   = "1.18"
  role_arn                  = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}
