#!/bin/bash

yum update -y --disableplugin=fastestmirror
systemctl restart sshd

yum install -y tar bzip2 nano git 
yum install -y httpd httpd-devel mod_ssl
yum install -y php php-common php-mysql php-pdo php-mcrypt* php-gd php-xml php-mbstring

echo "date.timezone = Europe/Bratislava" >> /etc/php.ini

if [ ! -e /vagrant/httpd.conf ]; 
then 
	cp /vagrant/public/vagrant/httpd.conf.sample /vagrant/httpd.conf
fi

if [ ! -e /vagrant/_ss_environment.php ]; 
then 
	cp /vagrant/public/vagrant/_ss_environment.php.sample /vagrant/_ss_environment.php
fi

echo "Include /vagrant/httpd.conf" >> /etc/httpd/conf/httpd.conf
systemctl start httpd.service
systemctl enable httpd.service

yum install -y mariadb-server mariadb
systemctl start mariadb.service
systemctl enable mariadb.service

iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT

# prepare theme for gulp
theme=$(grep -Po '"'"theme"'"\s*:\s*"\K([^"]*)' /vagrant/config.json)
if [ -d /vagrant/public/themes/${theme}/ ];
then
  echo 'found theme folder ' ${theme}

  if [ -e /vagrant/public/themes/${theme}/gulpfile.js ];
  then	
	  echo 'theme uses GULP (nodejs). Ready for mygulp task.'
	
	  # install node with nvm
	  runuser -l  vagrant -c 'wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash'

	  export THEME=$theme
	  if [ ! -d /home/vagrant/node_modules/ ];
	  then
		echo 'creating symlink for node modules'
		# directory must be "node_modules", do not ask me why. Some node modules can't be installed if real folder named different (even if symlink named node_modules)
		runuser -m  vagrant -c 'mkdir /home/vagrant/node_modules'
		runuser -m  vagrant -c 'ln -s /home/vagrant/node_modules/ /vagrant/public/themes/${THEME}/node_modules'
	  fi

	  #run this after box creation
	  echo 'run this after box creation: cd /vagrant/public/themes/${theme}/ && nvm install && npm install'
  elif [[ -e /vagrant/public/themes/${theme}/config.rb && -e /vagrant/public/themes/${theme}/bower.json ]];
  then
  	  echo 'theme uses bundler (ruby). Ready for mycompass task.'
      runuser -l  vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && curl -sSL https://get.rvm.io | bash -s stable --ruby && gem install bundler'
  else
      echo 'theme is plain, nothing to do'
  fi
fi

#install composer
if [ ! -e /usr/local/bin/composer ]; 
then
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php composer-setup.php
	php -r "unlink('composer-setup.php');"
	mv composer.phar /usr/local/bin/composer
fi

if [ ! -d /vagrant/public/assets ]; 
then 
	echo "Setup assets dir..."
	runuser -l  vagrant -c 'mkdir /vagrant/public/assets'
	chmod -R 0777 /vagrant/public/assets 
	echo "Assets folder chmoded to 777"
	rm -f assets/error-*.html
	echo "Pregenerated error pages removed"
fi

if [ ! -e /vagrant/public/assets/.htaccess ]; 
then 
	echo "Setup assets/.htaccess..."
	runuser -l  vagrant -c 'wget -O /vagrant/public/assets/.htaccess https://raw.githubusercontent.com/silverstripe/silverstripe-installer/master/assets/.htaccess'
fi

if [ -e /vagrant/public/composer.json ]; 
then 
	echo "Running composer install..."
	runuser -l  vagrant -c 'cd /vagrant/public/ && composer install'
fi

echo "phar.readonly = Off" >> /etc/php.ini
curl -sS https://silverstripe.github.io/sspak/install | php -- /usr/local/bin

if [ -e /vagrant/public/framework/sake ]; 
then
	chmod +x /vagrant/public/framework/sake
	echo "sake is now executable" 
	echo "Running sake install..."
	cd /vagrant/public && ./framework/sake installsake
fi





