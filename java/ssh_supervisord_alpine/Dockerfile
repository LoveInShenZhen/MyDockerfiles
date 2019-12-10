FROM mcr.microsoft.com/java/jdk:8u232-zulu-alpine

COPY setup_alpine.sh /usr/local/bin
COPY setup_zsh.sh /usr/local/bin

RUN /usr/local/bin/setup_alpine.sh

EXPOSE 22

CMD    ["/usr/bin/supervisord"]
    