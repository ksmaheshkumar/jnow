provider "aws" {
  version = "2.7"
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

data "aws_caller_identity" "current" {
  provider = "aws"
}

module "network" {
  source        = "../modules/network"
  name          = "${var.name}"
  vpc_cidr      = "${var.vpc_cidr}"
  public_subnet = "${var.public_subnet}"
  azs           = "${var.azs}"
}

module "global" {
  source     = "../modules/global"
  key_name   = "${var.key_name}"
  public_key = "${var.public_key}"
  vpc_id     = "${module.network.vpc_id}"
  name       = "${var.name}"
}

module "demo" {
  source           = "../modules/compute/demo"
  key_name         = "${var.key_name}"
  iam_id           = "${module.global.ec2_access_profile_id}"
  sg_id            = "${module.global.sg_ec2_id}"
  public_subnet_id = "${module.network.public_subnet_id}"
  ami		   = "${var.ami}"
  instance_type    = "${var.instance_type}"
  azs              = "${var.azs}"

}

