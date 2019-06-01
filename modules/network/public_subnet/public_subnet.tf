#--------------------------------------------------------------
# This module creates all resources necessary for a public
# subnet
#--------------------------------------------------------------

variable "name" {
  default = "public"
}

variable "vpc_id" {}
variable "cidrs" {}

resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${var.cidrs}"

  tags = {
    Name = "PublicSubet"
  }

  lifecycle {
    create_before_destroy = true
  }
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

output "subnet_id" {
  value = "${aws_subnet.public.id}"
}
