FROM mcr.microsoft.com/java/jdk:8u232-zulu-alpine

COPY setup_alpine.sh setup_zsh.sh /usr/local/bin/

RUN /usr/local/bin/setup_alpine.sh && /usr/local/bin/setup_zsh.sh

EXPOSE 22

CMD    ["/usr/bin/supervisord"]