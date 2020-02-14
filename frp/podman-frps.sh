#!/bin/sh
podman create \
    -d \
    --name frps \
    --net host \
    -v ./frps.ini:/etc/frp/frps.ini \
    --restart always \
    leeyanzhe/frp \
    frps -c frps.ini