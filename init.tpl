#!/bin/bash
echo "${mysql_address}" >> /home/ec2-user/db-address
echo "db_address=\$(cat /home/ec2-user/db-address)" > /home/ec2-user/bootstrap.sh
echo "sed -i \"s/localhost/\$db_address/\" /home/ec2-user/wordpress/wp-config.php" >> /home/ec2-user/bootstrap.sh
echo "sed -i \"s/database_name_here/wpdbname/\" /home/ec2-user/wordpress/wp-config.php" >> /home/ec2-user/bootstrap.sh
echo "sed -i \"s/username_here/wordpress/\" /home/ec2-user/wordpress/wp-config.php" >> /home/ec2-user/bootstrap.sh
echo "sed -i \"s/password_here/X1qaz2wsxX123456X/\" /home/ec2-user/wordpress/wp-config.php" >> /home/ec2-user/bootstrap.sh
chmod u+x /home/ec2-user/bootstrap.sh
./home/ec2-user/bootstrap.sh
sudo cp -r /home/ec2-user/wordpress/* /var/www/html/
sudo service httpd restart