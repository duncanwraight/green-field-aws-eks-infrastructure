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

variable "node_group" {
  type = object({
    instance_type = string
    min_size      = number
    max_size      = number
  })
}
