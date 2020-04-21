#!/bin/bash

docker build \
    -t leeyanzhe/graalvm:ee-java11 -t leeyanzhe/graalvm:ee-java11-20.0.1 \
    -f ee/base.dockerfile \
    .

docker build \
    -t leeyanzhe/graalvm:ee-java11-full -t leeyanzhe/graalvm:ee-java11-20.0.1-full \
    -f ee/full.dockerfile \
    .

docker push leeyanzhe/graalvm:ee-java11-20.0.1
docker push leeyanzhe/graalvm:ee-java11
docker push leeyanzhe/graalvm:ee-java11-20.0.1-full
docker push leeyanzhe/graalvm:ee-java11-full