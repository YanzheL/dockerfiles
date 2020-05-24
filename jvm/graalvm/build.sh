#!/bin/bash
GRAALVM_VERSION=20.1.0
docker build \
    --build-arg GRAALVM_VERSION=${GRAALVM_VERSION} \
    -t leeyanzhe/jvm:graalvm-ee-java11 -t leeyanzhe/jvm:graalvm-ee-java11-${GRAALVM_VERSION} \
    -f ee/base.dockerfile \
    .

docker build \
    --build-arg GRAALVM_VERSION=${GRAALVM_VERSION} \
    -t leeyanzhe/jvm:graalvm-ee-java11-full -t leeyanzhe/jvm:graalvm-ee-java11-${GRAALVM_VERSION}-full \
    -f ee/full.dockerfile \
    .

docker push leeyanzhe/jvm:graalvm-ee-java11-${GRAALVM_VERSION}
docker push leeyanzhe/jvm:graalvm-ee-java11
docker push leeyanzhe/jvm:graalvm-ee-java11-${GRAALVM_VERSION}-full
docker push leeyanzhe/jvm:graalvm-ee-java11-full