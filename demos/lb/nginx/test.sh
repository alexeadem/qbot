#!/bin/bash

if [ -z $1 ]; then
    echo $0 {address}
    exit 0
fi

(set -x; curl -kv -H 'host: cafe.example.com'  https://$1/tea)
#(set -x; curl -kv -H 'host: cafe.example.com'  https://136.24.65.146/tea)
#(set -x; curl -kv -H 'host: cafe.example.com'  https://136.24.65.147/tea)


