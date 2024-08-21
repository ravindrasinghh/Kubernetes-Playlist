
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

locals {
  environment                             = terraform.workspace
  k8s_info                                = lookup(var.environments, local.environment)
  cluster_name                            = lookup(local.k8s_info, "cluster_name")
  region                                  = lookup(local.k8s_info, "region")
  env                                     = lookup(local.k8s_info, "env")
  vpc_id                                  = lookup(local.k8s_info, "vpc_id")
  vpc_cidr                                = lookup(local.k8s_info, "vpc_cidr")
  public_subnet_ids                       = lookup(local.k8s_info, "public_subnet_ids")
  cluster_version                         = lookup(local.k8s_info, "cluster_version")
  cluster_enabled_log_types               = lookup(local.k8s_info, "cluster_enabled_log_types")
  eks_managed_node_groups                 = lookup(local.k8s_info, "eks_managed_node_groups")
  cluster_security_group_additional_rules = lookup(local.k8s_info, "cluster_security_group_additional_rules")
  coredns_config                          = lookup(local.k8s_info, "coredns_config")
  ecr_names                               = lookup(local.k8s_info, "ecr_names")

  prefix             = "${local.project}-${local.environment}-${var.region}"
  eks_access_entries = flatten([for k, v in local.k8s_info.eks_access_entries : [for s in v.user_arn : { username = s, access_policy = lookup(local.eks_access_policy, k), group = k }]])

  eks_access_policy = {
    viewer = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy",
    admin  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  }
  project    = "codedevops"
  account_id = data.aws_caller_identity.current.account_id
  default_tags = {
    environment = local.environment
    managed_by  = "terraform"
    project     = local.project
  }
}
