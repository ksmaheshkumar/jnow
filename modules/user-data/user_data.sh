#!/bin/bash
 sudo apt-get update
 sudo mkdir /ssl
 sudo openssl req -new -newkey rsa:4096 -nodes -keyout /ssl/www.mahesh.com.key -out /ssl/www.mahesh.com.csr  -subj "/C=IN/ST=KA/L=BLR/O=Dis/CN=www.mahesh.com"
 sudo openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=IN/ST=KA/L=BLR/O=Dis/CN=www.mahesh.com"  -keyout /ssl/www.mahesh.com.key  -out /ssl/www.mahesh.com.crt

echo "
sleep 60
sudo wget https://maheshnow.s3.amazonaws.com/helloworld.war  --limit-rate=500K -O helloworld.war
 sudo echo \"FROM gizmotronic/oracle-java
 MAINTAINER Mahesh
 COPY helloworld.war /home/helloworld.war
 CMD [\\\"java\\\",\\\"-jar\\\",\\\"/home/helloworld.war\\\"]\" >Dockerfile

 sudo docker build -t helloworld .

sudo docker run -d --name exec1 helloworld -p 8080

sudo a2enmod proxy proxy_http ssl


sudo rm /etc/apache2/sites-available/*
sudo rm /etc/apache2/sites-enabled/*

 ip=\`sudo docker inspect -f \"{{ .NetworkSettings.IPAddress }}\" exec1\`
echo \"<VirtualHost *:443>
    ProxyPass / http://$ip:8080/
    ProxyPassReverse / http://$ip:8080/
    SSLEngine on
    SSLProtocol all -SSLv2
    SSLCertificateKeyFile /ssl/www.mahesh.com.key
    SSLCertificateFile /ssl/www.mahesh.com.crt
    <Proxy *>
        Order deny,allow
        Allow from all
        Allow from localhost
    </Proxy>
</VirtualHost>

<VirtualHost *:80>

ProxyPass / http://$ip:8080/
ProxyPassReverse / http://$ip:8080/
<Proxy *>
    Order deny,allow
    Allow from all
    Allow from localhost
</Proxy>
</VirtualHost>\" >/tmp/mahesh.com.conf
sudo cp /tmp/mahesh.com.conf /etc/apache2/sites-available/mahesh.com.conf
sudo a2ensite mahesh.com.conf
sudo /etc/init.d/apache2 restart
" >/tmp/script2

sudo nohup bash /tmp/script2 >/home/ubuntu/output2 &
sudo apt-get install git docker.io apache2 -y

${user_data}
