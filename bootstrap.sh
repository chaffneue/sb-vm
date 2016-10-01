PASSWORD=admin

sudo apt-get update -q -y
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

sudo apt-get install -q -y python-software-properties
sudo apt-get remove  -q -y apparmor
sudo add-apt-repository ppa:ondrej/php5
sudo apt-get update -q -y

sudo apt-get install -q -y apache2 php5 php5-gd php5-intl php5-mysql php5-dev php5-curl phpmyadmin
sudo apt-get install -q -y php5-cli php5-xdebug php-pear php5-xsl git-core curl mysql-server-5.5 upstart samba
sudo apt-get install -q -y nodejs-legacy npm
sudo apt-get clean -y

sudo cp /home/vagrant/install/sb.conf /etc/apache2/sites-available/sb.conf
sudo cp /home/vagrant/install/phpmyadmin.conf /etc/apache2/sites-available/phpmyadmin.conf
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2ensite phpmyadmin
sudo apache2ctl restart

mkdir /home/vagrant/share
chmod 777 /home/vagrant/share
sudo cp /home/vagrant/install/smb.conf /etc/samba/smb.conf
echo -ne "vagrant\nvagrant\n" | sudo smbpasswd -a -s vagrant
sudo /etc/init.d/smbd restart

curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

sudo curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony

sudo service mysql stop
sudo service mysql start

cd /tmp
wget https://phar.phpunit.de/phpunit-old.phar
chmod +x phpunit-old.phar
sudo mv phpunit-old.phar /usr/local/bin/phpunit
phpunit --version

sudo npm install -g grunt-cli
