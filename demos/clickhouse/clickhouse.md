
# Supercharge ClickHouse Deployment on QBO

QBO is a cutting-edge platform that transforms bare-metal servers into powerful cloud solutions using containerized technology instead of traditional virtualization. This approach ensures metal performance, making it ideal for workloads like AI, databases, and real-time applications. This blog walks you through deploying **ClickHouse**, a columnar database, on QBO with optimal performance.

---

## Why QBO?

QBO leverages container technology for efficient resource utilization, providing:

- **Metal Performance**: Direct access to hardware for maximum efficiency.
- **Streamlined Management**: Eliminate VM overhead and simplify Kubernetes deployments.
- **Cost Efficiency**: Operate at a fraction of traditional cloud costs.

---

## Steps to Deploy ClickHouse on QBO

### 1. Verify the QBO CLI Installation
Ensure the CLI is installed and compatible:
```bash
qbo version | jq .version[]?
```

---

### 2. Add a ClickHouse Cluster
Add a new cluster for ClickHouse using a container-based Kubernetes node:
```bash
qbo add cluster clickhouse -i hub.docker.com/kindest/node:v1.32.0 | jq
```
If the cluster exists, QBO automatically fetches its details.

---

### 3. Retrieve Kubernetes Nodes
List all nodes in the cluster to verify the configuration:
```bash
qbo get nodes clickhouse | jq .nodes[]?
```

---

### 4. Configure Kubernetes
Set up Kubernetes access based on the environment:

#### Cloud Environment:
```bash
qbo get cluster clickhouse -k | jq -r '.output[]?.kubeconfig | select( . != null)' > $HOME/.qbo/clickhouse.conf
export KUBECONFIG=$HOME/.qbo/clickhouse.conf
```

#### On-Premises:
```bash
export KUBECONFIG=/tmp/qbo/clickhouse.conf
```

---

### 5. Deploy ClickHouse Operator
Install the ClickHouse operator to manage database deployment:
```bash
kubectl apply -f https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install-bundle.yaml
```

---

### 6. Deploy Custom Resource Definitions (CRD)
Apply the configuration for the ClickHouse instance:
```bash
kubectl apply -f simple-01-crd.yaml
```

---

### 7. Verify Deployment
Connect to the ClickHouse instance through the client:
```bash
$HOME/clickhouse client -h $LB -u test_user --password test_password
```

---

### 8. Create and Manage Databases

#### Create a Database:
```bash
$HOME/clickhouse client -h $LB -u test_user --password test_password --port 9000 --query "CREATE DATABASE IF NOT EXISTS moose;"
```

#### List Databases:
```bash
$HOME/clickhouse client -h $LB -u test_user --password test_password --port 9000 --query "SHOW DATABASES;"
```

---

## Final Notes

QBO simplifies the deployment and management of ClickHouse with its high-performance and cost-effective container technology. By leveraging QBO’s capabilities, developers and administrators can streamline complex workflows while maximizing hardware efficiency.