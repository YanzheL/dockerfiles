#!/bin/sh
podman create \
    -d \
    --name xray-s \
    --net host \
    -v ./config.json:/etc/xray/config.json \
    --restart always \
    leeyanzhe/xray:latest