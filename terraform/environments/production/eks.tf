module "eks_cluster" {
  source = "../../modules/eks_cluster"

  name = "production-eks"

  load_balancer = {
    subnet_ids = module.vpc.subnets.public.*.id
  }
}
