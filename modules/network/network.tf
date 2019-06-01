#--------------------------------------------------------------
# This module creates all networking resources
#--------------------------------------------------------------

variable "name" {}
variable "vpc_cidr" {}
variable "public_subnet" {}

module "vpc" {
 source = "./vpc"
 vpc_cidr="${var.vpc_cidr}"
 name= "${var.name}"
}

module "public_subnet" {
  source = "./public_subnet"
  name    = "${var.name}-public"
  vpc_id  = "${module.vpc.id}"
  cidrs   = "${var.public_subnet}"
}

# VPC
output "vpc_id" {
  value = "${module.vpc.id}"
}

# Subnets
output "public_subnet_id" {
  value = "${module.public_subnet.subnet_id}"
}

