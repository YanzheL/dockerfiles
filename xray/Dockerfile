FROM ubuntu:20.04 AS builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt -y update && \
    apt -y install curl jq git file pkg-config zip g++ zlib1g-dev unzip python openssl

ARG GOLANG_VERSION=1.15.8

RUN curl -L https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar -xvz -C /usr/local

ENV GOPATH /go

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

RUN mkdir -p ./src/xray/core && \
    git clone https://github.com/XTLS/Xray-core ./src/xray/core && \
    cd ./src/xray/core && \
    VERSION=$(curl -s https://github.com/XTLS/Xray-core/releases/latest |grep -oP '\d\.\d+\.\d+') && \
    git checkout tags/v${VERSION} && \
    go build -o xray -trimpath -ldflags "-s -w -buildid=" ./main && \
    mkdir /etc/xray && \
    mv xray /etc/xray/

# Use distroless as minimal base image to package the executable binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
# Note: Use registry.aliyuncs.com as repo-mirror if gcr.io is blocked by China GFW.
FROM gcr.io/distroless/base:latest
LABEL maintainer "Yanzhe Lee <lee.yanzhe@yanzhe.org>"
WORKDIR /etc/xray
COPY --from=builder /etc/xray .
ENV PATH /etc/xray:$PATH
CMD ["xray", "-config=/etc/xray/config.json"]
