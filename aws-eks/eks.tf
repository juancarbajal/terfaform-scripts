module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "gf-eks"
  cluster_version = "1.24"

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # cluster_addons = {
  #   coredns = {
  #     resolve_conflict = "OVERWRITE"
  #   }
  #   vpc-cni = {
  #     resolve_conflict = "OVERWRITE"
  #   }
  #   kube-proxy = {
  #     resolve_conflict = "OVERWRITE"
  #   }
  # }

  manage_aws_auth_configmap = false ## usuarios y accesos por terraform 

  eks_managed_node_groups = {
    node-groups = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_types   = ["t3.medium"]
      tags = {
        environment = "qa"
      }
    }
  }
}
