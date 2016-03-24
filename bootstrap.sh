#!/usr/bin/env bash
PASSWORD='root'

# update 
sudo apt-get update

# install apache and php5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# create werb folder
if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  mkdir /vagrant/html
  ln -fs /vagrant/html /var/www/html
fi

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql
sudo apt-get install php5-gd

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html"
    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install drush
wget http://files.drush.org/drush.phar
chmod +x drush.phar
mv drush.phar /usr/local/bin/drush

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer