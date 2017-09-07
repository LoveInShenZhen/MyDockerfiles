FROM centos:6
MAINTAINER "KK" <dragonsunmoon@163.com>
RUN yum clean all
RUN yum install -y yum-plugin-ovl || true
RUN yum install -y vim tar wget curl rsync bzip2 less net-tools lsof sysstat cronie python-setuptools openssh-server openssh-clients
RUN yum clean all

RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN easy_install supervisor
RUN /usr/bin/echo_supervisord_conf > /etc/supervisord.conf
RUN sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf
RUN echo [include] >> /etc/supervisord.conf
RUN echo 'files = /etc/supervisor/conf.d/*.conf' >> /etc/supervisord.conf

RUN mkdir -p /etc/supervisor/conf.d/
RUN echo '[program:sshd]' >> /etc/supervisor/conf.d/sshd.conf
RUN echo 'command=/usr/sbin/sshd -D' >> /etc/supervisor/conf.d/sshd.conf

RUN rm -f /etc/ssh/ssh*key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''

# 解决中文乱码的问题
RUN localedef -i zh_CN -f UTF-8 zh_CN.UTF-8

EXPOSE 22

RUN echo 'root:123456' | chpasswd
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN mkdir -p /root/.ssh
RUN chmod 600 /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDahS+x7LmavfZwMi90s5fM3gdliSBjjc/RIBLU4tH08nsKAUzIPj9glUjYW/Hb1aV1GPMhMiObhO+3q6qeseBWMLuv5+SD0e9K7Z3o9RZUP4ZS2ziOjyZWQp2ZN9zjPN+6D8qdJRGvqdRAFEeR24t9OqveQcNW3d1tYUQoOTtBEmtCFAtI+TRzahjqp5GEAc/svjTg5Us60D0qAPFa/JZo7hvjfxSoTZNuyLiB/0G7VNsVVijK0aIoWXn+4yDUuH77E/k0omWP2rWi0NZxArJvlVo6u51bc8An8hOdYs7JJoSLmRqei/A5QPO4UcTb34lwAZyWO8P6YRGd1HpdKsaB kk@kktekiMacBook-Pro.local' >> /root/.ssh/authorized_keys

CMD ["/usr/bin/supervisord"]