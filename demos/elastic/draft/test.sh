test=$(curl -s -H "authorization: Bearer FD8MHYyWkemaqEN8Ex" https://09a32493aa5d4f0b8409cce307ad330f.apm.us-central1.gcp.cloud.es.io:443/v1/traces | jq)

if [ ! -z "$test" ]; then
    echo $test | jq
fi
