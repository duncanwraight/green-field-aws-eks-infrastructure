module "decisioning" {
  source = "../../services/decisioning"

  name = "decisioning"
  environment = local.environment
}
