FROM golang:alpine

LABEL maintainer="Yanzhe Lee"

RUN apk add git \
    && go get github.com/jpillora/go-tcp-proxy/cmd/tcp-proxy \
    && ln -s /go/bin/tcp-proxy /usr/bin/