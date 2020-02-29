#!/bin/sh
podman create \
    -d \
    --name trojan \
    --net host \
    -v ./config.json:/etc/trojan/config.json \
    -v ./ssl:/etc/trojan/ssl \
    --restart always \
    trojangfw/trojan:latest