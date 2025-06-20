
# Using Load Balancers in QBO: A Step-by-Step Guide

QBO, with its containerized architecture and metal performance, simplifies networking and service management in Kubernetes. One of its standout features is the management of **kernel-level load balancing** using **IPVS (IP Virtual Server)**, providing a robust and efficient way to handle network traffic.

---

## Why Use Load Balancers in QBO?

Load balancers in QBO ensure:

- **Kernel-Level Efficiency with IPVS**: By leveraging IPVS, QBO manages load balancing directly at the kernel level, offering faster and more efficient packet handling compared to user-space alternatives.
- **Transparency**: Load balancers are deployed using standard Kubernetes constructs, making the integration seamless and requiring no additional user effort.
- **Efficient Traffic Distribution**: Balance incoming requests across multiple nodes or pods with minimal latency.
- **Scalability**: Adapt to increased traffic or node configurations effortlessly.

---

## Benefits of IPVS Load Balancers

QBO utilizes IPVS, a highly optimized kernel module for load balancing. The advantages of this approach include:

- **Low Overhead**: Since IPVS operates in the kernel space, it minimizes CPU and memory usage compared to user-space load balancers.
- **High Throughput**: Capable of handling a large number of concurrent connections with minimal latency.
- **Advanced Scheduling Algorithms**: Support for round-robin, least connection, and other algorithms ensures flexible and efficient traffic distribution.
- **Seamless Integration**: As the load balancers are managed via Kubernetes constructs, users don't need to configure IPVS directly, simplifying deployment.

---

## Steps to Use Load Balancers in QBO

### 1. Verify the QBO CLI Installation
Ensure the QBO CLI is installed:
```bash
qbo version | jq .version[]?
```

---

### 2. Add a Kubernetes Cluster
Add a cluster named `lb` for managing load balancers:
```bash
qbo add cluster lb -i hub.docker.com/kindest/node:v1.32.0 | jq
```

---

### 3. Retrieve Kubernetes Nodes
List all nodes in the cluster to verify configuration:
```bash
qbo get nodes lb | jq .nodes[]?
```

---

### 4. Configure Kubernetes
Set up the Kubernetes configuration for the cluster:

#### Cloud Environment:
```bash
qbo get cluster lb -k | jq -r '.output[]?.kubeconfig | select( . != null)' > $HOME/.qbo/lb.conf
export KUBECONFIG=$HOME/.qbo/lb.conf
```

#### On-Premises:
```bash
export KUBECONFIG=/tmp/qbo/lb.conf
```

---

### 5. Deploy and Test Services with Load Balancers

#### Apply Nginx Test Configurations
The script tests different configurations using Nginx services:
```bash
kubectl apply -f nginx/nginx-1-80.yaml
kubectl apply -f nginx/nginx-1-80-8080.yaml
kubectl apply -f nginx/nginx-1-8080.yaml
kubectl apply -f nginx/nginx-2-80.yaml
```

#### Check Load Balancer IPs
Monitor the load balancer IP addresses for each service:
```bash
kubectl get svc nginx-service-1 -o json | jq -r '.spec.externalIPs[0]'
```

#### Validate Service Availability
Use `curl` to check if the service is accessible via the load balancer:
```bash
curl -k -m 3 http://<LB_IP>:<PORT>
```

---

### 6. Cleanup and Reconfigure Services

#### Delete Services
Remove specific configurations as needed:
```bash
kubectl delete -f nginx/nginx-1-8080.yaml
kubectl delete -f nginx/nginx-2-80.yaml
```

#### Reapply and Patch Services
Reapply configurations and change service types dynamically:
```bash
kubectl apply -f nginx/nginx-1-80.yaml
kubectl patch svc nginx-service-1 -p '{"spec": {"type": "ClusterIP"}}'
kubectl patch svc nginx-service-1 -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc nginx-service-1 -p '{"spec": {"type": "NodePort"}}'
kubectl patch svc nginx-service-1 -p '{"spec": {"type": "LoadBalancer"}}'
```

---

## Final Notes

QBO's integration with IPVS for kernel-level load balancing ensures high performance, scalability, and low overhead. By abstracting these capabilities into Kubernetes constructs, QBO allows users to deploy and manage load balancers effortlessly. Whether you're scaling a service or optimizing traffic distribution, QBO makes the process seamless and efficient.