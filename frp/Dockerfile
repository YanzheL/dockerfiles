FROM alpine

LABEL maintainer="Yanzhe Lee"

WORKDIR /etc

RUN apk update \
    && apk add curl \
    && VERSION=$(curl -s https://github.com/fatedier/frp/releases/latest |grep -oP '\d\.\d+\.\d+') \
    && wget https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_amd64.tar.gz \
    && mkdir frp \
    && tar -zvxf *.gz -C frp --strip-components=1

WORKDIR /etc/frp

CMD ./frps -c frps.ini