#!/usr/bin/env bash

apt-get update
apt-get install -y apt-utils
apt-get install -y openssh-server supervisor iproute2 tzdata locales rsync unzip

mkdir /var/run/sshd

cp -f /usr/share/zoneinfo/Asia/Chongqing /etc/localtime

localedef -i zh_CN -f UTF-8 zh_CN.UTF-8

echo 'root:1qaz@WSX' |chpasswd

sed -ri 's/^#+PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

/usr/bin/echo_supervisord_conf > /etc/supervisord.conf
sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf
echo [include] >> /etc/supervisord.conf
echo 'files = /etc/supervisor/conf.d/*.conf /etc/supervisor/builtin_conf/*.conf' >> /etc/supervisord.conf

mkdir -p /etc/supervisor/conf.d/
mkdir -p /etc/supervisor/builtin_conf/
echo '[program:sshd]' >> /etc/supervisor/builtin_conf/sshd.conf
echo 'command=/usr/sbin/sshd -D' >> /etc/supervisor/builtin_conf/sshd.conf

mkdir -p /deploy

rm -rf /var/lib/apt/lists/*
apt-get autoclean
apt-get clean

# mkdir -p /root/.pip
# echo "[global]" >> /root/.pip/pip.conf
# echo "index-url=http://mirrors.aliyun.com/pypi/simple/" >> /root/.pip/pip.conf
# echo "format=columns" >> /root/.pip/pip.conf
# echo "[install]" >> /root/.pip/pip.conf
# echo "trusted-host=mirrors.aliyun.com" >> /root/.pip/pip.conf