#!/bin/sh
podman create \
    -d \
    --name trojan \
    --net host \
    -v ./config.json:/etc/trojan/config.json \
    --restart always \
    trojangfw/trojan:latest