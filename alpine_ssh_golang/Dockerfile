FROM golang:alpine3.8

# SSHD
ENV ROOT_PASSWORD 1qaz@WSX

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update	&& apk upgrade && apk add openssh zsh \
		&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
		&& echo "root:${ROOT_PASSWORD}" | chpasswd \
		&& rm -rf /var/cache/apk/* /tmp/* \
    && sed -i 's/\/bin\/ash/\/bin\/zsh/g' /etc/passwd \
    && echo 'export GOPATH="/go"' >> /etc/profile.d/golang.sh \
    && echo 'export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"' >> /etc/profile.d/golang.sh \
    && mkdir -p /root/.ssh

COPY entrypoint.sh /usr/local/bin/

EXPOSE 22

ENTRYPOINT ["entrypoint.sh"]
