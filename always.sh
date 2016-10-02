#!/bin/bash

if [ -d /vagrant/public/assets ];
then
  echo "setting permissions on assets folder"
	chmod -R 0777 /vagrant/public/assets
	echo "Assets folder chmoded to 777"
fi

cp -f /vagrant/public/vagrant/mygulp /usr/local/bin/mygulp
cp -f /vagrant/public/vagrant/mycomposer /usr/local/bin/mycomposer
cp -f /vagrant/public/vagrant/mysspak /usr/local/bin/mysspak
cp -f /vagrant/public/vagrant/mysake /usr/local/bin/mysake




