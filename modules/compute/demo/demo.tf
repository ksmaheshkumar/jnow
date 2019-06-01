variable "key_name" {}
variable "sg_id" {}
variable "iam_id" {}
variable "public_subnet_id" {}
variable "instance_type" {}
variable "ami" {}

resource "aws_instance" "demo" {
  instance_type = "${var.instance_type}"
  ami           = "${var.ami}"

  tags = {
    Name = "Demo"
  }

  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.sg_id}"]
  iam_instance_profile   = "${var.iam_id}"
  subnet_id              = "${var.public_subnet_id}"
  associate_public_ip_address = true
  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install docker httpd mod_ssl -y
sudo systemctl restart httpd

sudo systemctl restart httpd

sudo systemctl restart docker

sudo mkdir /install1
sudo wget https://maheshnow.s3.amazonaws.com/helloworld.war -O /install1/helloworld.war
 sudo wget https://maheshnow.s3.amazonaws.com/Dockerfile -O /install1/Dockerfile
 sudo wget https://maheshnow.s3.amazonaws.com/httpd.conf -O /install1/httpd.conf
 sudo wget https://maheshnow.s3.amazonaws.com/ssl.conf -O /install1/ssl.conf
cd /install1
 sudo docker build -f /install1/Dockerfile -t helloworld .

sudo docker run -d -p 8080:8080 --name exec1 helloworld 

sudo mkdir /ssl
sudo openssl req -new -newkey rsa:4096 -nodes -keyout /ssl/www.mahesh.com.key -out /ssl/www.mahesh.com.csr  -subj "/C=IN/ST=KA/L=BLR/O=Dis/CN=www.mahesh.com"
sudo openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=IN/ST=KA/L=BLR/O=Dis/CN=www.mahesh.com"  -keyout /ssl/www.mahesh.com.key  -out /ssl/www.mahesh.com.crt

sudo rm /etc/httpd/conf.d/ssl.conf
sudo rm /etc/httpd/conf/httpd.conf 
sudo cp /install1/httpd.conf /etc/httpd/conf/httpd.conf 
sudo cp /install1/ssl.conf /etc/httpd/conf.d/ssl.conf

sudo systemctl restart httpd

	EOF
}
