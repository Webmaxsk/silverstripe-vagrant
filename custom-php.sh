#!/bin/bash

# stiahni a nainstaluj EPEL / REMI
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7*.rpm epel-release-latest-7*.rpm

# nainstaluj yum-config-manager
yum install -y yum-utils

# povol php56
yum-config-manager --enable remi-php56

# nainstaluje sa nova verzia php
yum update -y

# downgrade
# sudo yum-config-manager --disable remi-php56
# sudo yum remove php*
# a potom nainstalovat php kniznice, ktore potrebujem (pripadne zbehnut vagrant provision)

# restartuj apache
service httpd restart
