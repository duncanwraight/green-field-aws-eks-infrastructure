module "wallet" {
  source = "../../services/wallet"

  name = "wallet"
  environment = local.environment
}
