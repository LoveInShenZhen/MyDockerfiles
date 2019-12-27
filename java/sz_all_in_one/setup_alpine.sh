#!/bin/sh
set -x

NGINX_VERSION='1.16.1'
NJS_VERSION='0.3.5'
PKG_RELEASE=1
ROOT_PASSWORD='loveinshenzhen'

sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
apk update && apk upgrade && apk add openssh unzip python3 bash rsync

sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config

echo "change root password: ${ROOT_PASSWORD}"
echo "root:${ROOT_PASSWORD}" | chpasswd

mkdir -p /root/.ssh
ssh-keygen -A

# install nginx, ref: https://github.com/nginxinc/docker-nginx/blob/a973c221f6cedede4dab3ab36d18240c4d3e3d74/stable/alpine/Dockerfile
# create nginx user/group first, to be consistent throughout docker variants
set -x && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && apkArch="$(cat /etc/apk/arch)" \
    && nginxPackages=" \
        nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE} \
    " \
    && case "$apkArch" in \
        x86_64) \
# arches officially built by upstream
            set -x \
            && KEY_SHA512="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de193c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin" \
            && apk add --no-cache --virtual .cert-deps \
                openssl \
            && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
            && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then \
                echo "key verification succeeded!"; \
                mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
            else \
                echo "key verification failed!"; \
                exit 1; \
            fi \
            && apk del .cert-deps \
            && apk add -X "https://nginx.org/packages/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
            ;; \
        *) \
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
            set -x \
            && tempDir="$(mktemp -d)" \
            && chown nobody:nobody $tempDir \
            && apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \
                make \
                openssl-dev \
                pcre-dev \
                zlib-dev \
                linux-headers \
                libxslt-dev \
                gd-dev \
                geoip-dev \
                perl-dev \
                libedit-dev \
                mercurial \
                bash \
                alpine-sdk \
                findutils \
            && su nobody -s /bin/sh -c " \
                export HOME=${tempDir} \
                && cd ${tempDir} \
                && hg clone https://hg.nginx.org/pkg-oss \
                && cd pkg-oss \
                && hg up -r 429 \
                && cd alpine \
                && make all \
                && apk index -o ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz ${tempDir}/packages/alpine/${apkArch}/*.apk \
                && abuild-sign -k ${tempDir}/.abuild/abuild-key.rsa ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz \
                " \
            && cp ${tempDir}/.abuild/abuild-key.rsa.pub /etc/apk/keys/ \
            && apk del .build-deps \
            && apk add -X ${tempDir}/packages/alpine/ --no-cache $nginxPackages \
            ;; \
    esac \
    && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi \
    && if [ -n "/etc/apk/keys/abuild-key.rsa.pub" ]; then rm -f /etc/apk/keys/abuild-key.rsa.pub; fi \
    && if [ -n "/etc/apk/keys/nginx_signing.rsa.pub" ]; then rm -f /etc/apk/keys/nginx_signing.rsa.pub; fi \
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    \
    && runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
    && apk add --no-cache tzdata \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# install supervisor
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple supervisor
mkdir -p /etc/supervisor/conf.d
mkdir -p /etc/supervisor/builtin_conf

/usr/bin/echo_supervisord_conf  > /etc/supervisord.conf
sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf

echo [include] >> /etc/supervisord.conf
echo 'files = /etc/supervisor/conf.d/*.conf /etc/supervisor/builtin_conf/*.conf' >> /etc/supervisord.conf

echo '[program:sshd]' > /etc/supervisor/builtin_conf/sshd.conf
echo 'command=/usr/sbin/sshd -D' >> /etc/supervisor/builtin_conf/sshd.conf
echo 'autostart=true' >> /etc/supervisor/builtin_conf/sshd.conf
echo 'autorestart=true' >> /etc/supervisor/builtin_conf/sshd.conf

echo '[program:nginx]' > /etc/supervisor/builtin_conf/nginx.conf
echo "command=nginx -g 'daemon off;'" >> /etc/supervisor/builtin_conf/nginx.conf
echo 'autostart=true' >> /etc/supervisor/builtin_conf/nginx.conf
echo 'autorestart=false' >> /etc/supervisor/builtin_conf/nginx.conf

# cleanup
rm -rf /var/cache/apk/* /tmp/*