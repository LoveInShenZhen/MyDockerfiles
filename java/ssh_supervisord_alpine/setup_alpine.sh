#!/bin/sh

ROOT_PASSWORD='loveinshenzhen'

sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
apk update && apk upgrade && apk add openssh unzip python3 bash rsync

sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config

echo "root:${ROOT_PASSWORD}" | chpasswd

rm -rf /var/cache/apk/* /tmp/*

mkdir -p /root/.ssh
ssh-keygen -A

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple supervisor
mkdir -p /etc/supervisor/conf.d
mkdir -p /etc/supervisor/builtin_conf

/usr/bin/echo_supervisord_conf  > /etc/supervisord.conf
sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf

echo [include] >> /etc/supervisord.conf
echo 'files = /etc/supervisor/conf.d/*.conf /etc/supervisor/builtin_conf/*.conf' >> /etc/supervisord.conf

echo '[program:sshd]' >> /etc/supervisor/builtin_conf/sshd.conf
echo 'command=/usr/sbin/sshd -D' >> /etc/supervisor/builtin_conf/sshd.conf

echo '199.232.68.133 raw.githubusercontent.com
199.232.68.133 user-images.githubusercontent.com
199.232.68.133 avatars2.githubusercontent.com
199.232.68.133 avatars1.githubusercontent.com' > /etc/hosts