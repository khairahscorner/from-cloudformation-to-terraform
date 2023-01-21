 #!/bin/bash

apt-get update -y
apt-get install apache2 -y
systemctl start apache2.service
cd /var/www/html
echo "Udacity Demo Web Server Up and Running!" > index.html