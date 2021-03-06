#!/usr/bin/env bash

echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list

apt-get update
apt-get install -y apt-utils
apt-get install -y openssh-server supervisor iproute2 tzdata locales

mkdir /var/run/sshd

cp -f /usr/share/zoneinfo/Asia/Chongqing /etc/localtime

localedef -i zh_CN -f UTF-8 zh_CN.UTF-8

echo 'root:123456' |chpasswd

sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

/usr/bin/echo_supervisord_conf > /etc/supervisord.conf
sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf
echo [include] >> /etc/supervisord.conf
echo 'files = /etc/supervisor/conf.d/*.conf' >> /etc/supervisord.conf

mkdir -p /etc/supervisor/conf.d/
echo '[program:sshd]' >> /etc/supervisor/conf.d/sshd.conf
echo 'command=/usr/sbin/sshd -D' >> /etc/supervisor/conf.d/sshd.conf

rm -rf /var/lib/apt/lists/*

mkdir -p /root/.pip
echo "[global]" >> /root/.pip/pip.conf
echo "index-url=http://mirrors.aliyun.com/pypi/simple/" >> /root/.pip/pip.conf
echo "format=columns" >> /root/.pip/pip.conf
echo "[install]" >> /root/.pip/pip.conf
echo "trusted-host=mirrors.aliyun.com" >> /root/.pip/pip.conf