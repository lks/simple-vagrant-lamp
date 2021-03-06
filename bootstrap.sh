sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo add-apt-repository -y ppa:ondrej/php5
sudo apt-get update
<<<<<<< HEAD
sudo apt-get -y install mysql-server-5.5 php5-mysql libsqlite3-dev apache2 php5 php5-dev build-essential php-pear npm
sudo apt-get install -y python-software-properties python g++ make

sudo apt-get -y install build-essential erlang-base-hipe erlang-dev erlang-manpages erlang-eunit erlang-nox libicu-dev libmozjs-dev libcurl4-openssl-dev pkg-config

sudo apt-get upgrade
sudo apt-get install -y nodejs
sudo apt-get -y install mysql-server-5.5 php5-mysql libsqlite3-dev apache2 php5 php5-dev build-essential php-pear nodejs npm
sudo apt-get install -y python-software-properties python g++ make php-apc
sudo npm install -g bower


# Set timezone
echo "America/New_York" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata


# Setup database
if [ ! -f /var/log/databasesetup ];
then
    echo "DROP DATABASE IF EXISTS wine-be-cool" | mysql -uroot -proot
    echo "CREATE USER 'cap1'@'localhost' IDENTIFIED BY 'cap1'" | mysql -uroot -proot
    echo "CREATE DATABASE wine-be-cool" | mysql -uroot -proot
    echo "GRANT ALL ON cap1.* TO 'cap1'@'localhost'" | mysql -uroot -proot
    echo "flush privileges" | mysql -uroot -proot


fi


# Apache changes
if [ ! -f /var/log/webserversetup ];
then
    echo "ServerName localhost" | sudo tee /etc/apache2/httpd.conf > /dev/null
    sudo a2enmod rewrite
    sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default

    sudo touch /var/log/webserversetup
fi


# Install Mailcatcher
if [ ! -f /var/log/mailcatchersetup ];
then
    sudo /opt/vagrant_ruby/bin/gem install mailcatcher

    sudo touch /var/log/mailcatchersetup
fi


# Install xdebug
if [ ! -f /var/log/xdebugsetup ];
then
    sudo pecl install xdebug
    XDEBUG_LOCATION=$(find / -name 'xdebug.so' 2> /dev/null)

    sudo touch /var/log/xdebugsetup
fi


# Configure PHP
if [ ! -f /var/log/phpsetup ];
then
    sudo sed -i '/;sendmail_path =/c sendmail_path = "/opt/vagrant_ruby/bin/catchmail"' /etc/php5/apache2/php.ini
    sudo sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
    sudo sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/apache2/php.ini
    sudo sed -i '/html_errors = Off/c html_errors = On' /etc/php5/apache2/php.ini
    echo "zend_extension='$XDEBUG_LOCATION'" | sudo tee -a /etc/php5/apache2/php.ini > /dev/null

    sudo touch /var/log/phpsetup
fi

# Add symfony create
cd /var/www/
php app/console doctrine:database:create


# Make sure things are up and running as they should be
mailcatcher --http-ip=192.168.56.101
sudo service apache2 restart
