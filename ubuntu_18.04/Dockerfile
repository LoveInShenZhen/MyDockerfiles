FROM       ubuntu:18.04
MAINTAINER KK <dragonsunmoon@163.com>

COPY setup_ubuntu.sh /usr/local/bin
COPY sources.list /etc/apt/sources.list

RUN /usr/local/bin/setup_ubuntu.sh

EXPOSE 22

CMD    ["/usr/bin/supervisord"]