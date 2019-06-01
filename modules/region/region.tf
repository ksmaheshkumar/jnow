#--------------------------------------------------------------
# This module is used to configure initial setup
#--------------------------------------------------------------

variable "domain" {}
variable "region_alias" {}
variable "vpc_id" {}
variable "region_domain" {}
variable "global_domain_zone_id" {}
variable "global_domain_nameservers" {
 type="list"
}

resource "aws_route53_zone" "region_domain" {
  name = "${var.region_alias}.${var.domain}"
}

resource "aws_route53_record" "dev-ns" {
  zone_id = "${var.global_domain_zone_id}"
  name    = "${var.region_domain}"
  type    = "NS"
  ttl     = "300"

  records =["${aws_route53_zone.region_domain.name_servers}"]
}


output "region_zone_id" {
  value = "${aws_route53_zone.region_domain.zone_id}"
}


