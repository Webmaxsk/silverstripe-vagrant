#!/bin/bash

if [ -d /vagrant/public/assets ]; then
    echo "setting permissions on assets folder"
    chmod -R 0777 /vagrant/public/assets
    echo "Assets folder chmoded to 777"
fi

if [ -d /vagrant/public/silverstripe-cacheinclude/cache ]; then
    echo "setting permissions on cacheinclude cache folder"
    chmod -R 0777 /vagrant/public/silverstripe-cacheinclude/cache
    echo "cacheinclude cache folder chmoded to 777"
fi

if [ ! -d /vagrant/sslogs ]; then
    mkdir /vagrant/sslogs
    echo "creating sslogs folder"
fi

echo "setting permissions on sslogs folder"
chmod -R 0777 /vagrant/sslogs
echo "sslogs folder chmoded to 777"

cp -f /vagrant/public/vagrant/mycompass /usr/local/bin/mycompass
cp -f /vagrant/public/vagrant/mycomposer /usr/local/bin/mycomposer
cp -f /vagrant/public/vagrant/mygulp /usr/local/bin/mygulp
cp -f /vagrant/public/vagrant/mysake /usr/local/bin/mysake
cp -f /vagrant/public/vagrant/mysspak /usr/local/bin/mysspak
