#!/bin/bash
podman create \
    --memory 500m \
    --net host \
    --entrypoint '["ss-manager", "-m", "chacha20", "-u", "--manager-address", "127.0.0.1:6001"]' \
    --name ss-manager \
    --user=root \
    shadowsocks/shadowsocks-libev
ln -s $(pwd)/ss-manager.service /etc/systemd/system/
systemctl enable ss-manager
service ss-manager start
