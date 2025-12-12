resource "aws_eks_cluster" "main" {
  name                      = "${var.env}-eks"
  role_arn                  = aws_iam_role.cluster.arn
  enabled_cluster_log_types = ["audit", "controllerManager"]
  version                   = var.eks_version

  vpc_config {
    subnet_ids = var.subnet_ids # This is where nodes are going to be provisioned. This is a multi-zonal kubernetes cluster
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
  ]
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster" {
  name               = "${var.env}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.eks_tags
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}


# Defines the retention of the enabled logs on cloud watch
resource "aws_cloudwatch_log_group" "logger" {
  name              = "/aws/eks/${var.env}-eks/logger"
  retention_in_days = 1
}

