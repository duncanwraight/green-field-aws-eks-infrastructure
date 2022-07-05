locals {
  name = "${var.name}-aurora-${var.engine}"
}

data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

variable "name" {
  type = string
}

variable "engine" {
  type        = string
  description = "mysql or postgresql, not the full engine string as seen in AWS"
}

variable "subnet_ids" {
  type = list(string)
}

variable "additional_security_group_ids" {
  type    = list(string)
  default = []
}

variable "backup" {
  type = object({
    retention_period = number
    window           = string
  })

  default = {
    retention_period = 7
    window           = "02:46-03:16"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
