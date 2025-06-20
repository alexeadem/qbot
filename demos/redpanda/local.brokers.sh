#!/bin/sh

# Get the Redpanda broker pods and their nodes
kubectl get pods -n redpanda -o wide --no-headers | while read pod; do
    pod_name=$(echo $pod | awk '{print $1}')
    node_name=$(echo $pod | awk '{print $7}')
    
    # Only process Redpanda broker pods (those with names like redpanda-<number>)
    if echo "$pod_name" | grep -q "^redpanda-[0-9]"; then
        # Find the internal IP of the node hosting the pod
        node_ip=$(kubectl get nodes -o wide --no-headers | grep "$node_name" | awk '{print $6}')
        
        # Print the IP and hostname mapping for brokers
        echo "$node_ip   $pod_name.cloud.eadem.com"
    fi
done
