#!/usr/bin/env bash
set -e
 
if [ `which nginx` ]
then
    exit 0
fi

#add nginx new version
echo "deb http://nginx.org/packages/ubuntu/ precise nginx" > /etc/apt/sources.list.d/nginx.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62

#install packages
aptitude update
locale-gen fr_FR.UTF-8
aptitude install -y nginx python-pip screen git apt-get ssl-cert

#generate certificate
make-ssl-cert generate-default-snakeoil --force-overwrite

# flask installation
pip install flask
su -c "screen -dm -S flask_server python /vagrant/api/server.py" vagrant

# websocket installation
su -c "cd /tmp; git clone git://github.com/ry/node.git; cd node; ./configure; make" vagrant
cd /tmp/node
make install
cd ..
rm -r node
su -c "cd /vagrant/websocket; npm install socket.io; screen -dm -S websocket_server node server.js" vagrant

# nginx configuration
mkdir /etc/nginx/sites-enabled/
cp /vagrant/nginx/nginx.conf /etc/nginx/
ln -fs /vagrant/nginx/modern_webapp /etc/nginx/sites-enabled
service nginx restart

