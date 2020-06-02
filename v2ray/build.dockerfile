FROM ubuntu:20.04 AS builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt -y update && \
    apt -y install curl jq git file pkg-config zip g++ zlib1g-dev unzip python openssl

ARG GOLANG_VERSION=1.14.3

RUN curl -L https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar -xvz -C /usr/local

ENV GOPATH /go

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

ARG BAZEL_VER=0.23.0

RUN curl -Lo bazel-installer.sh https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh && \
    chmod +x bazel-installer.sh && \
    ./bazel-installer.sh && \
    rm *.sh

# Configurable arguments defined at build time. User can override them by docker build --build-arg ARG_NAME=ARG_VALUE
# Default OS type = linux
ARG OS=linux
# Default architecture = 64
ARG ARCH=amd64

RUN go get -insecure -t v2ray.com/core/... && \
    cd src/v2ray.com/core && \
    VERSION=$(curl -s https://github.com/v2ray/v2ray-core/releases/latest |grep -oP '\d\.\d+\.\d+') && \
    git checkout tags/v${VERSION} && \
    bazel build --action_env=GOPATH=$GOPATH --action_env=PATH=$PATH //release:v2ray_${OS}_${ARCH}_package && \
    mkdir /etc/v2ray && \
    cd /etc/v2ray && \
    unzip $GOPATH/src/v2ray.com/core/bazel-bin/release/*.zip

# Use distroless as minimal base image to package the executable binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
# Note: Use gcr.mirrors.ustc.edu.cn as repo-mirror if gcr.io is blocked by China GFW.
FROM gcr.io/distroless/base:latest
LABEL maintainer "Yanzhe Lee <lee.yanzhe@yanzhe.org>"
WORKDIR /etc/v2ray
COPY --from=builder /etc/v2ray .
ENV PATH /etc/v2ray:$PATH
CMD ["v2ray", "-config=/etc/v2ray/config.json"]
