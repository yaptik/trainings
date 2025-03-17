#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql git nginx

# Secure MySQL installation
sudo mysql_secure_installation

# Clone the Git repository with configuration files
CONFIG_REPO="https://github.com/yaptik/trainings.git"
CONFIG_DIR="/tmp/web-configs"
git clone $CONFIG_REPO $CONFIG_DIR

# Install WordPress
sudo wget -O /var/www/html/wordpress.tar.gz https://wordpress.org/latest.tar.gz
sudo tar -xzvf /var/www/html/wordpress.tar.gz -C /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Configure Apache for WordPress using the config from Git
sudo cp $CONFIG_DIR/wordpress.conf /etc/apache2/sites-available/
sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

# Install another CMS (e.g., Joomla) on a subdomain
sudo wget -O /var/www/html/joomla.tar.gz https://downloads.joomla.org/cms/joomla3/3-9-27/Joomla_3-9-27-Stable-Full_Package.tar.gz
sudo tar -xzvf /var/www/html/joomla.tar.gz -C /var/www/html/
sudo mv /var/www/html/joomla /var/www/html/subdomain
sudo chown -R www-data:www-data /var/www/html/subdomain
sudo chmod -R 755 /var/www/html/subdomain

# Configure Apache for the subdomain using the config from Git
sudo cp $CONFIG_DIR/subdomain.conf /etc/apache2/sites-available/
sudo a2ensite subdomain.conf
sudo systemctl restart apache2

# Configure Nginx as a reverse proxy using the config from Git
sudo cp $CONFIG_DIR/proxy.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Clean up the cloned repository
rm -rf $CONFIG_DIR

# Send notification
echo "Stack successfully deployed" | mail -s "Deployment Notification" your-email@example.com

echo "Script completed successfully."
