module "eks_node_group" {
  source = "../../modules/eks_node_group"

  subnet_ids = module.vpc.subnets.eks.*.id

  node_group = {
    instance_type = "t3.medium"
    min_size = 3
    max_size = 6
  }
}
