#!/bin/sh
podman create \
    --name xray-s \
    --net host \
    -v ./config.json:/etc/xray/config.json \
    -v ./ssl:/etc/xray/ssl \
    --restart always \
    leeyanzhe/xray:latest