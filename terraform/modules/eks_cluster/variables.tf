data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

variable "name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "load_balancer" {
  type = object({
    subnet_ids = list(string)
  })
}
