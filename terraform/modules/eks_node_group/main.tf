resource "aws_eks_node_group" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_eks_cni,
    aws_iam_role_policy_attachment.eks_node_worker_node,
    aws_iam_role_policy_attachment.eks_node_ecr_ro
  ]

  node_group_name = "default-${random_string.aws_eks_node_group.result}"
  cluster_name    = aws_eks_cluster.this.name
  version         = aws_eks_cluster.this.version
  node_role_arn   = aws_iam_role.eks_node.arn

  instance_types = [var.node_group.instance_type]
  subnet_ids     = var.subnet_ids

  scaling_config {
    min_size     = var.node_group.min_size
    max_size     = var.node_group.max_size
    desired_size = var.node_group.min_size
  }

  tags = {
    Name = "${aws_eks_cluster.this.name}-default-node"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "eks_node" {
  name               = "${var.name}-eks-node"
  assume_role_policy = data.aws_iam_policy_document.sts_from_node.json
}

data "aws_iam_policy_document" "sts_from_node" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_eks_cni" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_node_worker_node" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr_ro" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_cloudwatch_agent" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
