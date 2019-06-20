FROM mcr.microsoft.com/java/jdk:8u212-zulu-alpine

# SSHD
ENV ROOT_PASSWORD 1qaz@WSX

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update	&& apk upgrade && apk add openssh unzip zsh python3 \
		&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
		&& echo "root:${ROOT_PASSWORD}" | chpasswd \
		&& rm -rf /var/cache/apk/* /tmp/* \
    && sed -i 's/\/bin\/ash/\/bin\/zsh/g' /etc/passwd \
    && mkdir -p /root/.ssh \
    && ssh-keygen -A \
    && pip3 install supervisor \
    && /usr/bin/echo_supervisord_conf  > /etc/supervisord.conf \
    && sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf \
    && echo [include] >> /etc/supervisord.conf \
    && echo 'files = /etc/supervisor/conf.d/*.conf /etc/supervisor/sshd.conf' >> /etc/supervisord.conf \
    && mkdir -p /etc/supervisor/conf.d/

COPY sshd.conf /etc/supervisor/

EXPOSE 22

CMD    ["/usr/bin/supervisord"]
    