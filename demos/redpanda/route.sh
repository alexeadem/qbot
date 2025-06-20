#!/bin/bash

shopt -s expand_aliases

CLI_IMAGE=levitas/cli:latest
if [ -f /.dockerenv ]; then
    alias qbo=cli
else
    alias qbo="docker run --rm --name qbo-cli -e QBO_HOST=$QBO_HOST -e QBO_PORT=$QBO_PORT -e QBO_UID=$QBO_UID -e QBO_AUX=$QBO_AUX --network host -i -v ~/.qbo:/tmp/qbo $CLI_IMAGE cli"
fi

qbo get ipvs -A | jq -r '.ipvs[]? | "sudo ip route add \(.vip) via \(.rip | sub("\\.[0-9]+$"; ".2"))"' | sort | uniq |  while read -r cmd; do $cmd; done
