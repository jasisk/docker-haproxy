FROM alpine:latest

MAINTAINER Jean-Charles Sisk <jeancharles@paypal.com>

ENV HAPROXY_VERSION=1.5.14-r0

RUN addgroup -S haproxy && adduser -Dh /var/lib/haproxy -G haproxy haproxy

RUN ARCH=$(ARCH=$(apk --print-arch); case $ARCH in x86_64)ARCH=amd64;; x86)ARCH=i386;; esac; echo $ARCH) && \
    set -x && \
    apk add --update ca-certificates && \
    apk add --update --virtual=gpg gnupg && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys \
    B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.4/gosu-${ARCH}" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.4/gosu-${ARCH}.asc" && \
    gpg --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu && \
    apk del --purge gpg && \
    rm -rf $HOME/.gnupg /var/cache/apk/*

RUN apk --update add haproxy=$HAPROXY_VERSION && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /data/haproxy && chown haproxy:haproxy /data/haproxy
VOLUME /data/haproxy
WORKDIR /data/haproxy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["haproxy"]
