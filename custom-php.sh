#!/bin/bash

# download and install EPEL / REMI
# ! installed in setup.sh - we need it for jpegoptim
#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
#rpm -Uvh remi-release-7*.rpm epel-release-latest-7*.rpm

# install yum-config-manager
yum install -y yum-utils

# enable php56
yum-config-manager --enable remi-php56

# new version will be installed
yum update -y

# restart apache
service httpd restart

# downgrade
# sudo yum-config-manager --disable remi-php56
# sudo yum remove php*
# vagrant provision
