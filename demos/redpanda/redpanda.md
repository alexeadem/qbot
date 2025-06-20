
# Simplified Redpanda Deployment on QBO for High-Performance Streaming

QBO's innovative container-based approach ensures that workloads like **Redpanda**, a streaming data platform, run with metal performance. This blog demonstrates how to deploy Redpanda on QBO while leveraging its containerized Kubernetes ecosystem.

---

## Why QBO?

QBO is ideal for Redpanda deployments because of its:

- **Pure Container Technology**: Simplifies containerized workloads for Redpanda clusters.
- **High Performance**: Bare-metal efficiency, critical for streaming workloads.
- **Scalability**: Effortless management of Kubernetes nodes for growing clusters.

---

## Steps to Deploy Redpanda on QBO

### 1. Verify the QBO CLI Installation
Ensure the CLI is installed:
```bash
qbo version | jq .version[]?
```

---

### 2. Add a Redpanda Cluster
Add a new Redpanda cluster with three nodes:
```bash
qbo add cluster redpanda -n 3 -i hub.docker.com/kindest/node:v1.32.0 | jq
```

---

### 3. List Nodes in the Cluster
Retrieve the list of nodes in the cluster:
```bash
qbo get nodes redpanda | jq .nodes[]?
```

---

### 4. Configure Kubernetes

#### Cloud Environment:
```bash
qbo get cluster redpanda -k | jq -r '.output[]?.kubeconfig | select( . != null)' > $HOME/.qbo/redpanda.conf
export KUBECONFIG=$HOME/.qbo/redpanda.conf
```

#### On-Premises:
```bash
export KUBECONFIG=/tmp/qbo/redpanda.conf
```

---

### 5. Deploy Cert-Manager
Install cert-manager to manage TLS certificates:
```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --set crds.enabled=true --namespace cert-manager --create-namespace
```

---

### 6. Deploy Redpanda Operator
Install and configure the Redpanda operator:
```bash
kubectl kustomize "https://github.com/redpanda-data/redpanda-operator//operator/config/crd?ref=v2.3.6-24.3.3" | kubectl apply --server-side -f -
helm repo add redpanda https://charts.redpanda.com
helm repo update redpanda
helm upgrade --install redpanda-controller redpanda/operator --namespace redpanda --set image.tag=v2.3.6-24.3.3 --create-namespace
```

---

### 7. Deploy Redpanda Cluster
Apply the Redpanda cluster configuration:
```bash
kubectl apply -f redpanda-cluster.yaml --namespace redpanda
kubectl get redpanda --namespace redpanda --watch
```

---

### 8. Expose Redpanda Service
Enable external access by patching the service to a LoadBalancer:
```bash
kubectl patch svc redpanda-external -n redpanda -p '{"spec":{"type":"LoadBalancer"}}'
```

---

### 9. Install RPK CLI
If RPK is not installed, download and configure it:
```bash
curl -LO https://github.com/redpanda-data/redpanda/releases/latest/download/rpk-linux-amd64.zip
mkdir -p ~/.local/bin
unzip rpk-linux-amd64.zip -d ~/.local/bin/
export PATH="~/.local/bin:$PATH"
```

---

### 10. Fetch Cluster Information
Retrieve cluster details using RPK:
```bash
rpk cluster info -X user=superuser -X pass=secretpassword -X sasl.mechanism=SCRAM-SHA-512
```

---

## Final Notes

QBO empowers Redpanda deployments with metal performance and scalability, making it ideal for streaming data applications. By leveraging QBO’s efficient container platform, developers can achieve high throughput and low latency for mission-critical workloads.