for i in $(kubectl get no --selector '!node-role.kubernetes.io/control-plane' -o json | jq -r '.items[].metadata.name'); do
        (set -x; kubectl label node $i feature.node.kubernetes.io/pci-10de.present=true)
done
