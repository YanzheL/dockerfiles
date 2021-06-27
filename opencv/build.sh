#!/bin/bash

OPENCV_VERSION=4.5.2

docker build \
    --network host \
    -f full.dockerfile \
    --target opencv_builder \
    --progress plain \
    -t leeyanzhe/opencv:dev-${OPENCV_VERSION} \
    --build-arg OPENCV_VERSION=${OPENCV_VERSION} \
    --build-arg BUILD_SHARED_LIBS=ON \
    --build-arg BUILD_opencv_world=OFF \
    . \
    && \
docker tag leeyanzhe/opencv:dev-${OPENCV_VERSION} leeyanzhe/opencv:dev && \
docker push leeyanzhe/opencv:dev-${OPENCV_VERSION} && \
docker push leeyanzhe/opencv:dev

docker build \
    --network host \
    -f full.dockerfile \
    --target opencv_builder \
    --progress plain \
    -t leeyanzhe/opencv:dev-world-${OPENCV_VERSION} \
    --build-arg OPENCV_VERSION=${OPENCV_VERSION} \
    --build-arg BUILD_SHARED_LIBS=ON \
    --build-arg BUILD_opencv_world=ON \
    . \
    && \
docker tag leeyanzhe/opencv:dev-world-${OPENCV_VERSION} leeyanzhe/opencv:dev-world && \
docker push leeyanzhe/opencv:dev-world-${OPENCV_VERSION} && \
docker push leeyanzhe/opencv:dev-world

docker build \
    --network host \
    -f full.dockerfile \
    --target runtime \
    --progress plain \
    -t leeyanzhe/opencv:runtime-${OPENCV_VERSION} \
    --build-arg OPENCV_VERSION=${OPENCV_VERSION} \
    --build-arg BUILD_SHARED_LIBS=ON \
    --build-arg BUILD_opencv_world=OFF \
    . \
    && \
docker tag leeyanzhe/opencv:runtime-${OPENCV_VERSION} leeyanzhe/opencv:runtime && \
docker push leeyanzhe/opencv:runtime-${OPENCV_VERSION} && \
docker push leeyanzhe/opencv:runtime

docker build \
    --network host \
    -f full.dockerfile \
    --target runtime \
    --progress plain \
    -t leeyanzhe/opencv:runtime-world-${OPENCV_VERSION} \
    --build-arg OPENCV_VERSION=${OPENCV_VERSION} \
    --build-arg BUILD_SHARED_LIBS=ON \
    --build-arg BUILD_opencv_world=ON \
    . \
    && \
docker tag leeyanzhe/opencv:runtime-world-${OPENCV_VERSION} leeyanzhe/opencv:runtime-world && \
docker push leeyanzhe/opencv:runtime-world-${OPENCV_VERSION} && \
docker push leeyanzhe/opencv:runtime-world