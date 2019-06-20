FROM       mcr.microsoft.com/java/jdk:8u212-zulu-ubuntu
MAINTAINER KK <dragonsunmoon@163.com>

COPY setup_ubuntu.sh /usr/local/bin
COPY sources.list /etc/apt/sources.list

RUN /usr/local/bin/setup_ubuntu.sh

EXPOSE 22

# VOLUME /etc/supervisor/conf.d/
# VOLUME /deploy

CMD    ["/usr/bin/supervisord"]