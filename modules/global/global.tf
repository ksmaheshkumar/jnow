#--------------------------------------------------------------
# This module creates all resources necessary for global config
#--------------------------------------------------------------

variable "key_name" {}
variable "public_key" {}
variable "vpc_id" {}
variable "name" {}

resource "aws_key_pair" "site_key" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key)}"
}

#-------- IAM Role -----------------------------------------------------
resource "aws_iam_role" "ec2_access_role" {
  name = "EC2_ACCESS_ROLE"
  description = "Role to manage network interface, s3 and volume."
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
   "Action": "sts:AssumeRole",
   "Principal": {
      "Service": "ec2.amazonaws.com"
  },
   "Effect": "Allow",
   "Sid": ""
   }
  ]
}
EOF
}


#------ Attach global policies with ARN ----------------------------------

resource "aws_iam_role_policy_attachment" "attach-s3-policy" {
  role       = "${aws_iam_role.ec2_access_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


resource "aws_iam_role_policy_attachment" "attach-ec2-full-access" {
  role       = "${aws_iam_role.ec2_access_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}


#------ Map the IAM role to Profile and Use it in EC2 Resource ------------

resource "aws_iam_instance_profile" "ec2_access_profile" {
  name = "EC2-Privileges"
  role = "${aws_iam_role.ec2_access_role.name}"
}

output "ec2_access_profile_id" {
  value = "${aws_iam_instance_profile.ec2_access_profile.id}"
}

output "keypair_id" {
  value = "${aws_key_pair.site_key.id}"
}

#-----------------------Ec2-instance-Security Group-------------------------------------

resource "aws_security_group" "sg_ec2" {
  name        = "${var.name}-ec2-sg"
  description = "Used for access to the dev instance."
  vpc_id      = "${var.vpc_id}"

  # SSH

  
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

#  ingress {
#    from_port   = 8080
#    to_port     = 8080
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
#    security_group_id   = 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "sg_ec2_id" {
  value = "${aws_security_group.sg_ec2.id}"
}

#-----------------------LB Security Group-------------------------------------

resource "aws_security_group" "sg_lb" {
  name        = "${var.name}-lb-sg"
  description = "Used for access to the dev instance."
  vpc_id      = "${var.vpc_id}"

  # SSH

  
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#  ingress {
#    from_port   = 8080
#    to_port     = 8080
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "sg_lb_id" {
  value = "${aws_security_group.sg_lb.id}"
}
