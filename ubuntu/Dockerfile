FROM       ubuntu:16.04
MAINTAINER KK <dragonsunmoon@163.com>

COPY setup_ubuntu.sh /usr/local/bin

RUN /usr/local/bin/setup_ubuntu.sh

EXPOSE 22

CMD    ["/usr/bin/supervisord"]