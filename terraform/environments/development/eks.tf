module "eks_cluster" {
  source = "../../modules/eks_cluster"

  name = "development-eks"

  load_balancer = {
    subnet_ids = module.vpc.subnets.public.*.id
  }
}
