# AlpineLinux with a glibc-2.27-r0 and Oracle Java 8
FROM anapsix/alpine-java:8_jdk_unlimited

# SSHD
ENV ROOT_PASSWORD 1qaz@WSX

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update	&& apk upgrade && apk add openssh unzip zsh \
		&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
		&& echo "root:${ROOT_PASSWORD}" | chpasswd \
		&& rm -rf /var/cache/apk/* /tmp/* \
    && sed -i 's/\/bin\/ash/\/bin\/zsh/g' /etc/passwd \
    && echo 'export PATH=/opt/jdk/bin:$PATH' > /etc/profile.d/jdk.sh \
    && mkdir -p /root/.ssh

COPY entrypoint.sh /usr/local/bin/

EXPOSE 22

ENTRYPOINT ["entrypoint.sh"]
