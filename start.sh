#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
mkdir -p /data
cd /data
/etc/init.d/nginx start
pip3 install requests bs4 html5lib
cp -R gnupg /root/.gnupg
cp cron/sync_repos /etc/cron.d/
chmod 700 /root/.gnupg
ip="192.168.1.172:41000"
echo "export http_proxy=$ip" >> /etc/profile
echo "export https_proxy=$ip" >> /etc/profile
cron -f
