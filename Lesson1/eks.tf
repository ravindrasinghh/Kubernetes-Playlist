module "eks" {
  source                                 = "terraform-aws-modules/eks/aws"
  version                                = "20.13.1"
  cluster_name                           = local.cluster_name
  cluster_version                        = local.cluster_version
  cluster_enabled_log_types              = local.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = 30
  cluster_endpoint_public_access         = true

  cluster_addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      configuration_values        = jsonencode(local.coredns_config)
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent              = true
      service_account_role_arn = aws_iam_role.vpc_cni.arn
    }
  }

  vpc_id     = local.vpc_id
  subnet_ids = local.public_subnet_ids
  eks_managed_node_group_defaults = {
    ## This instance type (m6a.large) is a placeholder and will not be used in the actual deployment.

  }

  eks_managed_node_groups = local.eks_managed_node_groups

  cluster_security_group_additional_rules = local.cluster_security_group_additional_rules

  enable_cluster_creator_admin_permissions = false

  access_entries = {
    for k in local.eks_access_entries : k.username => {
      kubernetes_groups = []
      principal_arn     = k.username
      policy_associations = {
        single = {
          policy_arn = k.access_policy
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  tags = local.default_tags
}
#Role for vpc cni
resource "aws_iam_role" "vpc_cni" {
  name               = "${local.prefix}-vpc-cni"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${module.eks.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${module.eks.oidc_provider}:sub": "system:serviceaccount:kube-system:aws-node"
        }
      }
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}
