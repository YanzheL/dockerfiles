#!/bin/sh
podman create \
    -d \
    --name v2ray-s \
    --net host \
    -v ./config.json:/etc/v2ray/config.json \
    --restart always \
    leeyanzhe/v2ray:latest