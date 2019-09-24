#!/bin/bash

_APISERVER=127.0.0.1:8080
_V2CTL="docker-compose exec v2ray-s v2ctl"

apidata () {
    local ARGS=
    if [[ $1 == "reset" ]]; then
      ARGS="reset: true"
    fi
    $_V2CTL api --server=$_APISERVER StatsService.QueryStats "${ARGS}"
}

DATA=$(apidata $1)
echo "$DATA"
