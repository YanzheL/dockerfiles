
# LICENSE UPL 1.0
#
# Copyright (c) 2015 Oracle and/or its affiliates. All rights reserved.
#

FROM oraclelinux:7-slim

# Note: If you are behind a web proxy, set the build variables for the build:
#       E.g.:  docker build --build-arg "https_proxy=..." --build-arg "http_proxy=..." --build-arg "no_proxy=..." ...

RUN yum update -y oraclelinux-release-el7 \
    && yum install -y oraclelinux-developer-release-el7 oracle-softwarecollection-release-el7 \
    && yum-config-manager --enable ol7_developer \
    && yum-config-manager --enable ol7_developer_EPEL \
    && yum-config-manager --enable ol7_optional_latest \
    && yum install -y bzip2-devel ed gcc gcc-c++ gcc-gfortran gzip file fontconfig less libcurl-devel make openssl openssl-devel readline-devel tar vi which xz-devel zlib-devel \
    && yum install -y glibc-static libcxx libcxx-devel libstdc++-static zlib-static \
    && rm -rf /var/cache/yum

ARG GRAALVM_VERSION=20.0.1
ARG JAVA_VERSION=java11
# ARG GRAALVM_PKG=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$GRAALVM_VERSION/graalvm-ce-$JAVA_VERSION-GRAALVM_ARCH-$GRAALVM_VERSION.tar.gz 
ARG TARGETPLATFORM=linux-amd64

ENV LANG=en_US.UTF-8 \
    JAVA_HOME=/opt/graalvm-ee-$JAVA_VERSION-$GRAALVM_VERSION

RUN fc-cache -f -v

ADD gu-wrapper.sh /usr/local/bin/gu
ADD graalvm-ee-java11-${TARGETPLATFORM}-${GRAALVM_VERSION}.tar.gz /opt/
ADD native-image-installable-svm-svmee-${JAVA_VERSION}-${TARGETPLATFORM}-${GRAALVM_VERSION}.jar /opt/
RUN set -eux \

    # Set alternative links
    && mkdir -p "/usr/java" \
    && ln -sfT "$JAVA_HOME" /usr/java/default \
    && ln -sfT "$JAVA_HOME" /usr/java/latest \
    && for bin in "$JAVA_HOME/bin/"*; do \
        base="$(basename "$bin")"; \
        [ ! -e "/usr/bin/$base" ]; \
        alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
    done \

    && chmod +x /usr/local/bin/gu \

    && gu -L install /opt/native-image-installable-svm-svmee-${JAVA_VERSION}-${TARGETPLATFORM}-${GRAALVM_VERSION}.jar

CMD java -version