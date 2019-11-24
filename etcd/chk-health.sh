#!/bin/bash
docker exec -e ETCDCTL_API=3 \
etcd \
etcdctl \
--cert /etc/etcd/pki/healthcheck-client.crt \
--key /etc/etcd/pki/healthcheck-client.key \
--cacert /etc/etcd/pki/ca.crt \
--endpoints https://localhost:2379 endpoint health
