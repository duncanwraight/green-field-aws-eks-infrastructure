data "aws_availability_zones" "available" {}

variable "name_prefix" {
  type    = string
  default = "tf-"
}

variable "name" {
  type = string
}

variable "enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "cidr_block" {
  description = "CIDR blocks wanted to be used for your VPC (min /23)."
  type        = string
  default     = "172.31.0.0/16"
}
