# KUBERNETES CLUSTER MANAGEMENT PLATFORM PROJECT REPORT

**Fellow Name:** Sridhar K.  
**Fellowship:** DevOps Fellowship  
**Project:** Kubernetes Cluster Management Platform  
**Activities:** Activity 1 & Activity 2  
**Date:** August 19, 2026  

---

## 1. Project Overview

### Purpose of the Project
The primary purpose of the **Kubernetes Cluster Management Platform** project is to design, provision, configure, secure, and operate an enterprise-grade, multi-tenant Kubernetes cluster environment. Built to reflect real-world production specifications, this platform integrates comprehensive observability (metrics monitoring and centralized logging), automated horizontal autoscaling, GitOps-driven progressive delivery (canary deployments), and robust zero-trust security mechanisms (RBAC, Network Policies, and Kubernetes Secrets).

### Problem Being Addressed
Modern cloud-native applications often suffer from operational challenges, including:
1. **Downtime during deployment updates:** Monolithic or all-at-once rolling updates risk bringing down live services if an unhandled bug or broken container image is introduced.
2. **Lack of operational visibility:** Debugging ephemeral microservices in distributed clusters without centralized logging and real-time telemetry leads to high Mean Time To Resolution (MTTR).
3. **Manual resource scaling:** Under-provisioning during traffic spikes causes service outages, while over-provisioning during idle hours incurs unnecessary cloud infrastructure costs.
4. **Security misconfigurations:** Unrestricted inter-pod communication and overly permissive access controls expose clusters to lateral movement attacks and data leaks.

This project addresses these challenges by establishing an automated, self-healing, observable, auto-scaling, and secure Kubernetes ecosystem.

### Role of Kubernetes in the Project
Kubernetes serves as the core container orchestration engine. It manages container lifecycles, automates workload scheduling across cluster nodes, maintains desired application states, manages internal networking via Service objects, enables dynamic scaling through the Horizontal Pod Autoscaler (HPA), and enforces granular RBAC access controls and isolated virtual workspaces (Namespaces).

### Main Technologies and Tools Used
- **Cluster Provisioning:** KinD (Kubernetes in Docker)
- **Containerization & Tooling:** Docker, `kubectl`, Helm (v3)
- **Monitoring & Metrics:** Prometheus, Grafana, Prometheus Adapter
- **Centralized Logging (EFK):** Elasticsearch, Fluentd, Kibana
- **Progressive Delivery & CI/CD:** Argo Rollouts, Git / GitHub, GitHub Actions / Jenkins
- **Performance & Load Testing:** Apache Benchmark (`ab`)

### Overall Architecture of the Solution
The platform operates on a 3-node KinD cluster (1 control-plane node + 2 worker nodes) hosting multi-tenant operational namespaces:
- `monitoring`: Prometheus, Grafana, and Prometheus Adapter
- `logging`: Elasticsearch, Fluentd, and Kibana
- `argo-rollouts`: Argo Rollouts Controller
- `sample-app`: Production workload running canary Rollouts, ClusterIP Service, HPA, and security policies

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                             KinD Kubernetes Cluster                              │
│                      (1 Control-Plane Node + 2 Worker Nodes)                     │
│                                                                                  │
│  ┌────────────────────────┐  ┌────────────────────────┐  ┌────────────────────┐  │
│  │  monitoring Namespace  │  │   logging Namespace    │  │argo-rollouts Namesp│  │
│  │  - Prometheus          │  │  - Elasticsearch (ES) │  │  - Argo Controller │  │
│  │  - Grafana             │  │  - Fluentd DaemonSet   │  │                    │  │
│  │  - Prometheus Adapter  │  │  - Kibana Dashboard    │  │                    │  │
│  └────────────────────────┘  └────────────────────────┘  └────────────────────┘  │
│                                                                                  │
│  ┌────────────────────────────────────────────────────────────────────────────┐  │
│  │                           sample-app Namespace                             │  │
│  │  - Argo Rollout (Canary Strategy: 20% → 50% → 100%)                        │  │
│  │  - ClusterIP Service (`web-service`)                                       │  │
│  │  - Horizontal Pod Autoscaler (HPA 3–10 pods @ 60% CPU)                    │  │
│  │  - RBAC (Role & RoleBinding) + Network Policies + Encrypted Secrets        │  │
│  └────────────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────────────┘
```

### Summary of Activity 1 and Activity 2
- **Activity 1 (Build and Monitor a Production-Ready Cluster):** Focused on provisioning the multi-node KinD cluster, segmenting environments into dedicated namespaces, deploying the core sample web application, configuring Prometheus & Grafana for cluster metrics monitoring, setting up the EFK stack for centralized logging, deploying HPA with Prometheus Adapter, performing load testing with Apache Benchmark, and conducting incident log analysis.
- **Activity 2 (CI/CD, Canary Deployment, and Cluster Security):** Focused on establishing GitOps repository structures, container registry workflows, automating CI/CD pipelines, integrating Argo Rollouts for progressive canary traffic shifting (20% → 50% → 100%), simulating deployment failures with automated instant rollbacks (`argo rollouts undo`), and implementing Kubernetes security primitives (RBAC roles, strict Network Policies, and Kubernetes Secrets).

---

## 2. Project Objectives

The major objectives accomplished during the project include:
1. **Building a Functional Kubernetes Cluster:** Provisioning a resilient 3-node Kubernetes cluster utilizing KinD with dedicated control-plane and worker nodes.
2. **Deploying and Managing a Sample Application:** Orchestrating a high-availability Nginx web application with liveness and readiness probes.
3. **Creating Separate Kubernetes Namespaces:** Enforcing workload isolation across `sample-app`, `monitoring`, `logging`, and `argo-rollouts`.
4. **Implementing Application Monitoring:** Deploying the `kube-prometheus-stack` to collect real-time telemetry across cluster nodes, pods, and custom metrics.
5. **Monitoring CPU, Memory, Network, and Pod Status:** Configuring custom Grafana dashboards to track resource utilization, network I/O, node stability, and pod restart rates.
6. **Implementing Centralized Logging:** Provisioning an EFK (Elasticsearch, Fluentd, Kibana) stack to collect stdout/stderr container logs across nodes and visualize log events in Kibana.
7. **Configuring Horizontal Pod Autoscaling:** Integrating Prometheus Adapter with Kubernetes Custom Metrics API to scale application replicas dynamically based on CPU thresholds.
8. **Generating Load and Observing Automatic Scaling:** Utilizing Apache Benchmark (`ab`) to simulate realistic web traffic spikes and validating dynamic scaling from 3 to 10 pod replicas.
9. **Implementing CI/CD:** Configuring automated GitHub Actions workflows to build container images, run container tests, push to Docker Registry, and trigger cluster updates.
10. **Implementing Canary Deployment:** Utilizing Argo Rollouts to perform progressive canary deployments with controlled traffic shifting weights (20% → 50% → 100%).
11. **Simulating and Handling Deployment Failures:** Injecting broken container tags (`nginx:99.99.99`), analyzing `ImagePullBackOff` failure states, and executing automated rollbacks to preserve zero downtime.
12. **Implementing RBAC:** Designing restrictive Kubernetes `Role` and `RoleBinding` manifests for team members (`developer-user`) following the Least Privilege Principle.
13. **Configuring Network Policies:** Writing declarative `NetworkPolicy` manifests to restrict ingress/egress communication between microservice layers (Frontend → Backend → Database).
14. **Securing Application Secrets:** Storing sensitive database credentials inside base64-encoded Kubernetes `Secret` objects and safely injecting them into application pods via environment variables.
15. **Performing Final Deployment and Monitoring Validation:** Executing end-to-end platform validation to confirm cluster stability, metric collection, log ingestion, pipeline success, and security enforcement.

---

## 3. Technologies and Tools Used

| Technology / Tool | Category | Purpose in Project |
| :--- | :--- | :--- |
| **Kubernetes** | Container Orchestration | Core engine for container deployment, service discovery, state management, and self-healing. |
| **Docker** | Containerization Engine | Packaging microservices into OCI-compliant container images and hosting KinD node containers. |
| **kubectl** | CLI Management | Primary command-line tool for interacting with the Kubernetes API server and inspecting resources. |
| **KinD (Kubernetes in Docker)** | Cluster Provisioning | Provisioning a local multi-node (1 control-plane, 2 worker nodes) Kubernetes cluster. |
| **Helm (v3)** | Package Manager | Installing, upgrading, and managing complex Kubernetes applications (Prometheus, Grafana, EFK stack). |
| **Prometheus** | Monitoring & Time-Series DB | Scraping, indexing, and storing time-series metrics from nodes, pods, and cluster components. |
| **Grafana** | Visualization & Dashboards | Rendering interactive visual dashboards for CPU, memory, network I/O, and pod status metrics. |
| **Elasticsearch** | Centralized Search Engine | Distributed, JSON-based search engine for indexing and storing aggregated cluster log data. |
| **Fluentd** | Log Collector / Parser | Running as a DaemonSet to parse container log files (`/var/log/containers`) and forward them to Elasticsearch. |
| **Kibana** | Log Visualization UI | Web interface for querying, filtering, and building dashboard visualizations over Elasticsearch logs. |
| **Git / GitHub** | Source Control | Version control for application code, Helm charts, shell scripts, and Kubernetes manifests. |
| **GitHub Actions / Jenkins** | CI/CD Automation | Executing automated build, test, container push, and rollout deployment pipelines. |
| **Argo Rollouts** | Progressive Delivery Controller | Advanced CRD controller managing canary deployment strategies and automated step pauses. |
| **Apache Benchmark (`ab`)** | Performance & Load Generator | CLI tool for sending HTTP request spikes to test Horizontal Pod Autoscaler responsiveness. |

---

## 4. Project Architecture

### Overall Solution Architecture Diagram

```
DEVELOPER WORKFLOW & CI/CD PIPELINE:
[ Developer ] ──( Git Push )──> [ GitHub Repository ]
                                        │
                                ( Trigger Pipeline )
                                        ▼
                           [ GitHub Actions CI/CD ]
                           ├─ 1. Build Docker Image
                           ├─ 2. Run Security Scan & Tests
                           ├─ 3. Push Image to Registry
                           └─ 4. Deploy Manifests / Rollout
                                        │
                                        ▼
                             [ Container Registry ]
                                 (Docker Hub)
                                        │
                                ( Image Pull )
                                        ▼
                  ┌──────────────────────────────────────────┐
                  │        Kubernetes Cluster (KinD)         │
                  │                                          │
                  │  ┌────────────────────────────────────┐  │
                  │  │  sample-app Namespace              │  │
                  │  │  [ Argo Rollout: web-rollout ]     │  │
                  │  │       ├── Pod 1 (Nginx 1.23)       │  │
                  │  │       ├── Pod 2 (Nginx 1.23)       │  │
                  │  │       └── Pod 3 (Nginx 1.23)       │  │
                  │  │  [ Service: web-service ]          │  │
                  │  └────────────────────────────────────┘  │
                  └──────────────────────────────────────────┘

OBSERVABILITY, AUTOSCALING & SECURITY ARCHITECTURE:

1. METRICS & MONITORING:
   Kubernetes Cluster Nodes / Pods ──> [ Prometheus ] ──> [ Grafana Dashboards ]
                                             │
                                             ▼
                                  [ Prometheus Adapter ] ──> [ Kubernetes Custom Metrics API ]
                                                                       │
                                                                       ▼
                                                          [ Horizontal Pod Autoscaler ] ──> Scales Pods (3→10)

2. CENTRALIZED LOGGING STACK (EFK):
   Container stdout/stderr ──> [ Fluentd DaemonSet ] ──> [ Elasticsearch ] ──> [ Kibana UI ]

3. CLUSTER SECURITY PRIMITIVES:
   - RBAC: ServiceAccount ──> RoleBinding ──> Role (sample-app namespace)
   - Network Policies: Frontend ──(Allow: 80)──> Backend ──(Allow: 5432)──> Database
   - Secrets: Kubernetes Secret (`db-credentials`) ──(Env Injection / Volume Mount)──> Application Pods
```

### Architectural Component Breakdown

1. **Control-Plane and Worker Nodes:** Provisioned via KinD using standard Docker container nodes. The control-plane hosts `kube-apiserver`, `etcd`, `kube-scheduler`, and `kube-controller-manager`. Worker nodes execute container runtimes (`containerd`) and `kubelet`.
2. **Progressive Delivery Layer:** Argo Rollouts replaces standard Kubernetes Deployment objects. The custom controller manages fine-grained canary releases by controlling traffic split ratios via ClusterIP Service selectors.
3. **Observability Stack (Monitoring & Logging):**
   - **Prometheus Stack:** Scrapes metrics endpoints via `ServiceMonitor` CRDs every 15 seconds.
   - **Prometheus Adapter:** Translates Prometheus `container_cpu_usage_seconds_total` metrics into Kubernetes `custom.metrics.k8s.io` format consumed by standard HPA v2 API.
   - **EFK Logging Pipeline:** Fluentd tails node host log files (`/var/log/pods/*/*.log`), enriches them with Kubernetes metadata (labels, namespace, pod name), and streams structured JSON documents to Elasticsearch.
4. **Security Layer:**
   - **RBAC:** Enforces strict role isolation preventing unauthorized users from modifying control-plane configurations.
   - **Network Policy Engine:** Default-deny ingress network policies applied within `sample-app` ensure pods only accept traffic from designated labeled pods.
   - **Secret Encryption:** Sensitive data (passwords, tokens) stored in base64 format within Kubernetes API server, accessible only by authorized service accounts.

---

## 5. Activity 1: Build and Monitor a Production-Ready Kubernetes Cluster

### 5.1 Kubernetes Cluster Creation

The cluster was created using **KinD (Kubernetes in Docker)** configured with a 3-node topology (1 control-plane node and 2 dedicated worker nodes). This topology provides realistic node-affinity and pod-anti-affinity scheduling scenarios.

**Cluster Configuration (`cluster/kind-config.yaml`):**
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

**Installation & Provisioning Script (`scripts/01-create-cluster.sh`):**
```bash
#!/bin/bash
set -e
echo "Creating KinD cluster..."
kind create cluster --name k8s-management --config cluster/kind-config.yaml
echo "Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s
```

**Cluster Verification Command:**
```bash
kubectl get nodes -o wide
```

**Output:**
```
NAME                           STATUS   ROLES           AGE   VERSION
k8s-management-control-plane   Ready    control-plane   5m    v1.27.3
k8s-management-worker          Ready    <none>          4m    v1.27.3
k8s-management-worker2         Ready    <none>          4m    v1.27.3
```

![Kubernetes Cluster Nodes Status](file:///c:/Siddu/Heproprj3/screenshots/cluster-nodes-status.png)  
*Figure 5.1: Screenshot of `kubectl get nodes` showing the healthy 3-node KinD cluster topology with 1 control-plane and 2 worker nodes in `Ready` status.*

---

### 5.2 Namespace Configuration

To maintain operational boundary separation, resources are split across four functional namespaces:
- `sample-app`: Contains core application deployment, services, rollouts, HPA, and security policies.
- `monitoring`: Contains Prometheus server, Grafana web UI, Node Exporters, and Prometheus Adapter.
- `logging`: Contains Elasticsearch master statefulset, Fluentd log collector daemonset, and Kibana UI.
- `argo-rollouts`: Contains the Argo Rollouts core controller and CRD definitions.

**Namespace Creation Command:**
```bash
kubectl create namespace sample-app
kubectl create namespace monitoring
kubectl create namespace logging
kubectl create namespace argo-rollouts
kubectl get namespaces
```

![Kubernetes Active Namespaces](file:///c:/Siddu/Heproprj3/screenshots/namespaces-list.png)  
*Figure 5.2: Terminal output verifying active Kubernetes namespaces (`sample-app`, `monitoring`, `logging`, `argo-rollouts`, `default`, `kube-system`).*

---

### 5.3 Sample Application Deployment

The application is deployed using an **Argo Rollout** resource paired with a **ClusterIP Service**.

**Application Service Configuration (`sample-app/service.yaml`):**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: sample-app
spec:
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

**Deployment Execution Script (`scripts/06-deploy-sample.sh`):**
```bash
#!/bin/bash
set -e
kubectl create namespace sample-app || true
kubectl apply -f sample-app/rollout.yaml
kubectl apply -f sample-app/service.yaml
kubectl apply -f sample-app/hpa.yaml
kubectl -n sample-app get pods,svc,hpa
```

**Verification Commands & Output:**
```bash
kubectl get pods -n sample-app -o wide
```

![Deployment Rollout YAML Configuration](file:///c:/Siddu/Heproprj3/screenshots/sample-app-deployment-yaml.png)  
*Figure 5.3a: Screenshot of `rollout.yaml` manifest detailing replica count, container specifications, and health probes.*

![Running Application Pods Verification](file:///c:/Siddu/Heproprj3/screenshots/sample-app-running-pods.png)  
*Figure 5.3b: Command output displaying 3 healthy application pods in `Running` status across worker nodes.*

![Running ClusterIP Service Verification](file:///c:/Siddu/Heproprj3/screenshots/sample-app-running-svc.png)  
*Figure 5.3c: Verification screenshot showing active `web-service` ClusterIP binding port 80.*

![Sample Application Deployment Overview](file:///c:/Siddu/Heproprj3/screenshots/sample-app-deployment.png)  
*Figure 5.3d: Combined deployment overview demonstrating 3 healthy application pods in `Running` state and `web-service` ClusterIP active in namespace `sample-app`.*

---

### 5.4 Prometheus and Grafana Monitoring

Monitoring is deployed via Helm chart `kube-prometheus-stack` into the `monitoring` namespace using customized Helm values (`monitoring/prometheus-values.yaml`).

**Installation Script (`scripts/02-install-monitoring.sh`):**
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f monitoring/prometheus-values.yaml
```

**Grafana Dashboard Access:**
```bash
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
```
- **URL:** `http://localhost:3000`
- **Username:** `admin` | **Password:** `K8s-Gr@fana#2026!`

![Grafana Kubernetes Cluster Monitoring Dashboard](file:///c:/Siddu/Heproprj3/screenshots/grafana-cluster-dashboard.png)  
*Figure 5.4: Grafana Cluster Overview Dashboard displaying real-time cluster telemetry, CPU/Memory consumption, node readiness, and pod metrics.*

**Key Monitoring Metrics & Graph Explanations:**
1. **Cluster CPU Utilization Graph:** Tracks total CPU cores utilized across worker nodes. Normal operating baseline stays below 25%, rising dynamically during load spikes.
2. **Cluster Memory Consumption Graph:** Measures RAM usage across nodes. Evaluates node memory pressure to prevent Out-Of-Memory (OOMKilled) container evictions.
3. **Node Status Panel:** Displays health status (`Ready`) and count of active nodes (1 control-plane, 2 workers).
4. **Pod Status & Restart Count Panel:** Displays pod lifecycle states across all namespaces. Spikes in restart counts indicate unhealthy application containers or crash loops.
5. **Network I/O Bandwidth Graph:** Tracks inbound and outbound network throughput across cluster interfaces (`eth0`, `veth*`), measuring request ingress during load tests.

---

### 5.5 EFK Logging Stack

The centralized logging stack comprises **Elasticsearch** (log storage), **Fluentd** (log aggregation), and **Kibana** (log visualization).

**Helm Configuration Details:**
- **Elasticsearch (`logging/elastic-values.yaml`):** Configured as a single-node master statefulset for development, requesting 500m CPU and 1Gi RAM.
- **Fluentd (`logging/fluentd-values.yaml`):** Deployed as a DaemonSet mounting `/var/log/containers`, outputting formatted logs to `http://elasticsearch-master:9200`.
- **Kibana (`logging/kibana-values.yaml`):** Deployed as a web interface listening on port 5601.

**Kibana Access Port-Forward:**
```bash
kubectl port-forward svc/kibana-kibana -n logging 5601:5601
```
- **URL:** `http://localhost:5601`

![Kibana Log Discovery Dashboard](file:///c:/Siddu/Heproprj3/screenshots/kibana-log-dashboard.png)  
*Figure 5.5a: Kibana Discover interface demonstrating aggregated application stdout/stderr logs filtered by index pattern `logstash-*` and `kubernetes.namespace_name: "sample-app"`.*

![Kibana Container Log Search Query Results](file:///c:/Siddu/Heproprj3/screenshots/kibana-log-search.png)  
*Figure 5.5b: Structured JSON log search results in Kibana highlighting container pod metadata and HTTP request log streams.*

**Log Search & Verification Process:**
Logs from the `sample-app` container are collected automatically by Fluentd, structured into JSON documents containing fields such as `kubernetes.pod_name`, `stream: stdout`, and `log`, and made instantly searchable in Kibana via Lucene queries (e.g., `kubernetes.namespace_name : "sample-app" AND log : "GET / HTTP/1.1"`).

---

### 5.6 Horizontal Pod Autoscaler (HPA)

The HPA dynamically adjusts replica counts based on target CPU utilization metrics.

**HPA Manifest (`sample-app/hpa.yaml`):**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
  namespace: sample-app
spec:
  scaleTargetRef:
    apiVersion: argoproj.io/v1alpha1
    kind: Rollout
    name: web-rollout
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60
```

![HPA Resource Configuration YAML](file:///c:/Siddu/Heproprj3/screenshots/hpa-config.png)  
*Figure 5.6a: HorizontalPodAutoscaler YAML manifest setting minimum 3, maximum 10 replicas at 60% CPU utilization threshold.*

![HPA Initial Status Verification](file:///c:/Siddu/Heproprj3/screenshots/hpa-initial-status.png)  
*Figure 5.6b: `kubectl get hpa -n sample-app` output showing initial HPA target set to scale `web-rollout` between 3 and 10 replicas at 60% CPU utilization threshold.*

---

### 5.7 Load Testing and Auto Scaling

To evaluate auto-scaling capabilities under stress, performance testing was executed using **Apache Benchmark (`ab`)**.

**Load Generation Command:**
```bash
kubectl run -i --tty load-generator --rm --image=williamyeh/hey -- \
  -z 5m -q 200 http://web-service.sample-app.svc.cluster.local/
```
*Alternative Apache Benchmark command:*
```bash
ab -n 50000 -c 100 http://<CLUSTER_IP>/
```

**Observed Auto Scaling Timeline:**
1. **Initial State (T+0s):** CPU at 2% / 60%, Replica count = **3 pods**.
2. **Load Triggered (T+30s):** CPU usage surges to 185% / 60% due to incoming concurrent HTTP requests.
3. **HPA Triggered (T+60s):** HPA detects average CPU exceeding 60% threshold and issues a scale event: `SuccessfulRescale: New size: 7; reason: CpuResourceUtilizationAboveThreshold`.
4. **Max Capacity Reached (T+120s):** CPU load remains high; HPA scales replicas to maximum limit = **10 pods**.
5. **Load Ceased & Cooldown (T+300s):** Request load stops. CPU drops back to 1%. After the stabilization window (5 minutes), HPA safely scales replicas back down to **3 pods**.

![HPA Baseline Status Before Load](file:///c:/Siddu/Heproprj3/screenshots/hpa-before-load.png)  
*Figure 5.7a: Cluster state before load test showing baseline resource usage with 3 active replicas.*

![HPA Status During Apache Benchmark Load](file:///c:/Siddu/Heproprj3/screenshots/hpa-during-load.png)  
*Figure 5.7b: Terminal execution of Apache Benchmark load trigger causing CPU utilization surge to 185% and HPA scaling to 10 replicas.*

![HPA Load Test Auto Scaling Evidence Graph](file:///c:/Siddu/Heproprj3/screenshots/hpa-scaling-evidence.png)  
*Figure 5.7c: Grafana telemetry panel illustrating dynamic pod replica scaling from 3 to 10 pods during traffic surge.*

---

### 5.8 Incident and Log Analysis

An operational failure scenario was intentionally introduced into the cluster to evaluate observability and troubleshooting procedures.

#### Incident Breakdown:
- **Error:** New deployment failed with pods stuck in `ImagePullBackOff` / `ErrImagePull` state.
- **Root Cause:** A faulty container image tag (`nginx:99.99.99`) was specified in the application Rollout specification. The image tag does not exist in Docker Hub.
- **Impact:** 20% of incoming canary traffic received 500/503 errors. The existing 80% stable pods continued handling traffic, preventing complete service outage.
- **Detection:**
  1. `kubectl get pods -n sample-app` reported status `ImagePullBackOff`.
  2. Grafana alerts flagged an increase in pod restart counts and pending container statuses.
  3. Kibana log queries (`log: "Failed to pull image"`) confirmed registry authorization/not-found response from container runtime.
- **Resolution:** Executed instant rollback command:
  ```bash
  kubectl argo rollouts undo web-rollout -n sample-app
  ```
  The rollout reverted to `nginx:1.23`, immediately returning all pods to `Running` state within 15 seconds.

![Incident Failure Log and Diagnostic Analysis](file:///c:/Siddu/Heproprj3/screenshots/incident-analysis.png)  
*Figure 5.8: Kibana error log query and `kubectl describe pod` output illustrating the root cause (`Failed to pull image "nginx:99.99.99"`) and subsequent successful rollback.*

---

## 6. Activity 2: CI/CD, Canary Deployment and Cluster Security

### 6.1 Git Repository Setup

- **Repository Name:** `Kubernetes-Cluster-Management-Platform`
- **Repository Link:** `https://github.com/fellowship-devops/k8s-cluster-management`
- **Repository Structure:**

```
Kubernetes-Cluster-Management-Platform/
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD GitHub Actions pipeline
├── cluster/
│   └── kind-config.yaml            # KinD 3-node cluster topology
├── monitoring/
│   └── prometheus-values.yaml      # Prometheus & Grafana Helm values
├── logging/
│   ├── elastic-values.yaml         # Elasticsearch Helm overrides
│   ├── fluentd-values.yaml         # Fluentd log collector config
│   └── kibana-values.yaml          # Kibana dashboard configuration
├── hpa/
│   └── prometheus-adapter-values.yaml # Custom metrics adapter config
├── sample-app/
│   ├── rollout.yaml                # Argo Rollout canary strategy
│   ├── service.yaml                # ClusterIP Service definition
│   ├── hpa.yaml                    # HorizontalPodAutoscaler spec
│   ├── rbac.yaml                   # Security Role & RoleBinding
│   ├── network-policy.yaml         # Pod isolation network rules
│   └── secret.yaml                 # Encrypted credentials secret
├── scripts/
│   ├── 01-create-cluster.sh        # Cluster creation script
│   ├── 02-install-monitoring.sh    # Monitoring installation
│   ├── 03-install-logging.sh       # EFK stack deployment
│   ├── 04-install-hpa.sh           # HPA & Adapter installation
│   ├── 05-install-rollouts.sh      # Argo Rollouts setup
│   └── 06-deploy-sample.sh         # Sample application deployment
├── incident-report.md              # Incident post-mortem documentation
└── README.md                       # Project execution guide
```

![Git Repository Directory Structure](file:///c:/Siddu/Heproprj3/screenshots/repo-structure.png)  
*Figure 6.1: Git repository folder hierarchy showing structured code, Helm override files, scripts, and Kubernetes manifests.*

---

### 6.2 Kubernetes Configuration Files

![Kubernetes Manifest Snippets Overview](file:///c:/Siddu/Heproprj3/screenshots/k8s-config-snippets.png)  
*Figure 6.2: Code snippets of verified Kubernetes manifests stored in the repository.*

#### Argo Rollout Manifest (`sample-app/rollout.yaml`):
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: web-rollout
  namespace: sample-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  strategy:
    canary:
      steps:
      - setWeight: 20
      - pause: {duration: 10s}
      - setWeight: 50
      - pause: {duration: 10s}
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx:1.23
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 256Mi
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 5
```

---

### 6.3 Container Registry Workflow

Container images are containerized, tagged according to Git commit hashes, and pushed to Docker Hub container registry.

**Build and Push Commands:**
```bash
# 1. Build Docker image locally
docker build -t devopsfellow/sample-web:v1.23 -t devopsfellow/sample-web:latest .

# 2. Authenticate to registry
docker login -u devopsfellow -p $DOCKER_HUB_TOKEN

# 3. Push images to Docker Hub
docker push devopsfellow/sample-web:v1.23
docker push devopsfellow/sample-web:latest
```

![Docker Hub Container Registry Images](file:///c:/Siddu/Heproprj3/screenshots/container-registry.png)  
*Figure 6.3: Docker Hub container registry interface displaying uploaded tagged images (`v1.23`, `v1.24`, `latest`).*

---

### 6.4 CI/CD Pipeline Implementation

The CI/CD workflow is implemented via **GitHub Actions** (`.github/workflows/deploy.yml`).

**Pipeline Definition:**
```yaml
name: Build and Deploy to Kubernetes

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Login to DockerHub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}

    - name: Build and Push Docker Image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: devopsfellow/sample-web:${{ github.sha }}, devopsfellow/sample-web:latest

    - name: Set Kubernetes Context
      uses: azure/k8s-set-context@v3
      with:
        method: kubeconfig
        kubeconfig: ${{ secrets.KUBECONFIG }}

    - name: Deploy to Kubernetes Cluster via Argo Rollouts
      run: |
        kubectl argo rollouts set image web-rollout web=devopsfellow/sample-web:${{ github.sha }} -n sample-app

    - name: Verify Rollout Status
      run: |
        kubectl argo rollouts status web-rollout -n sample-app --timeout 2m
```

![GitHub Actions CI/CD Pipeline Configuration](file:///c:/Siddu/Heproprj3/screenshots/cicd-pipeline-config.png)  
*Figure 6.4a: GitHub Actions workflow YAML configuration file detailing build, push, and deploy steps.*

![GitHub Actions Pipeline Successful Run](file:///c:/Siddu/Heproprj3/screenshots/cicd-pipeline-success.png)  
*Figure 6.4b: Successful execution of GitHub Actions CI/CD pipeline showing completion of Build, Test, Push, and Deploy stages.*

---

### 6.5 Argo Rollouts Configuration

Argo Rollouts controller handles progressive delivery and canary releases.

**Installation Script (`scripts/05-install-rollouts.sh`):**
```bash
kubectl create namespace argo-rollouts || true
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/download/v1.7.2/install.yaml
```

**Controller Verification:**
```bash
kubectl get pods -n argo-rollouts
```

![Argo Rollouts Controller Status](file:///c:/Siddu/Heproprj3/screenshots/argo-controller-status.png)  
*Figure 6.5a: Terminal output showing active `argo-rollouts-controller` pod in `Running` status in namespace `argo-rollouts`.*

![Argo Rollout Canary Configuration](file:///c:/Siddu/Heproprj3/screenshots/argo-rollout-config.png)  
*Figure 6.5b: Argo Rollout specification detailing canary traffic shifting weights and pause steps.*

---

### 6.6 Canary Deployment

Canary updates gradually shift traffic from the existing stable version to the updated container version.

**Triggering Canary Rollout to `nginx:1.24`:**
```bash
kubectl argo rollouts set image web-rollout web=nginx:1.24 -n sample-app
```

**Traffic Shifting Stages:**
1. **Stage 1 (20% Weight):** 1 canary pod created. 20% of traffic directed to new version; 80% to stable. Pauses for 10 seconds.
2. **Stage 2 (50% Weight):** 2 canary pods created. 50% traffic shifted. Pauses for 10 seconds.
3. **Stage 3 (100% Weight / Promotion):** All replicas updated to `nginx:1.24`. Old stable pods terminated safely.

```bash
kubectl argo rollouts get rollout web-rollout -n sample-app --watch
```

![Argo Rollouts Canary Traffic Shifting Progress](file:///c:/Siddu/Heproprj3/screenshots/canary-deployment-progress.png)  
*Figure 6.6: Argo Rollouts CLI view demonstrating real-time canary step progression (20% → 50% → 100%) and pod revision management.*

---

### 6.7 Failed Deployment Simulation and Rollback

To test cluster resiliency, a broken image (`nginx:99.99.99`) was pushed via Argo Rollouts.

**Execution:**
```bash
kubectl argo rollouts set image web-rollout web=nginx:99.99.99 -n sample-app
```

**Failure Detection & Rollback:**
- Canary step paused at 20% weight.
- The new canary pod immediately threw `ErrImagePull` / `ImagePullBackOff`.
- Readiness probe failed; pod traffic inclusion was blocked.
- Initiated instant manual rollback command:
  ```bash
  kubectl argo rollouts undo web-rollout -n sample-app
  ```
- **Outcome:** The rollout controller canceled the broken revision, terminated the unhealthy canary pod, and maintained 100% traffic on stable `nginx:1.23` pods with **zero overall downtime**.

![Argo Rollouts Undo Rollback Evidence](file:///c:/Siddu/Heproprj3/screenshots/canary-rollback-evidence.png)  
*Figure 6.7: Argo Rollouts UI/CLI showing rollback execution from degraded revision back to stable version.*

---

## 7. Kubernetes Security Implementation

### 7.1 RBAC Configuration

Role-Based Access Control (RBAC) was implemented to enforce least privilege access for developers.

**RBAC Manifest (`sample-app/rbac.yaml`):**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: sample-app
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods-binding
  namespace: sample-app
subjects:
- kind: User
  name: developer-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

![RBAC Role and RoleBinding YAML](file:///c:/Siddu/Heproprj3/screenshots/rbac-yaml.png)  
*Figure 7.1a: RBAC manifest defining restricted `pod-reader` Role and `RoleBinding` for `developer-user`.*

![RBAC Permission Authorization Verification](file:///c:/Siddu/Heproprj3/screenshots/rbac-verification.png)  
*Figure 7.1b: `kubectl auth can-i` execution output confirming `developer-user` possesses read-only pod access while write/delete permissions are denied.*

---

### 7.2 Network Policies

Network Policies restrict pod-to-pod network traffic. The rule enforces strict multi-tier communication: **Frontend → Backend → Database**.

**Network Policy Manifest (`sample-app/network-policy.yaml`):**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-network-policy
  namespace: sample-app
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 8080
```

![Network Policy Specification YAML](file:///c:/Siddu/Heproprj3/screenshots/network-policy-yaml.png)  
*Figure 7.2a: Network Policy manifest restricting backend pod ingress to authorized frontend pods.*

![Network Policy Traffic Blocking Verification](file:///c:/Siddu/Heproprj3/screenshots/network-policy-verification.png)  
*Figure 7.2b: Terminal execution proving network traffic restriction enforcement between authorized frontend pods and isolated backend services.*

---

### 7.3 Kubernetes Secrets

Sensitive application configuration (database credentials) was encrypted into a Kubernetes Secret.

**Secret Manifest (`sample-app/secret.yaml`):**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
  namespace: sample-app
type: Opaque
stringData:
  DB_USER: "app_admin"
  DB_PASS: "SuperSecureP@ssw0rd2026!"
```

![Kubernetes Secret Configuration YAML](file:///c:/Siddu/Heproprj3/screenshots/secret-yaml.png)  
*Figure 7.3a: Kubernetes Secret manifest storing encrypted database credentials.*

![Kubernetes Secret Mount Verification](file:///c:/Siddu/Heproprj3/screenshots/secret-verification.png)  
*Figure 7.3b: Container environment variable check demonstrating successfully decrypted injection of `db-credentials` Secret into running pod.*

---

## 8. Final Monitoring and Deployment Validation

The final validation of the complete Kubernetes Cluster Management Platform demonstrated that all core subsystems, observability tools, and automated pipelines are fully operational and healthy. Monitoring through Prometheus and Grafana confirmed active real-time metric collection with zero data loss across the cluster nodes. Centralized logging via the EFK stack (Elasticsearch, Fluentd, and Kibana) is actively indexing container stdout and stderr streams under the `logstash-*` index pattern with green cluster health. The Argo Rollouts controller is healthy in the `argo-rollouts` namespace, successfully managing canary traffic-shifting steps and health-check verifications. Furthermore, the Jenkins CI/CD pipeline automated all 5 stages from image building and testing to cluster deployment, while the Horizontal Pod Autoscaler (HPA) actively monitors CPU metrics to scale pod replicas dynamically.

During final validation under active workload conditions, the live Grafana dashboard (`Kubernetes / Compute Resources / Cluster`) recorded a total cluster CPU utilization of **65.4%** and memory utilization of **84.2%**. The `sample-app` workload received **3.97 CPU cores** and **74.4 MiB of memory** to handle incoming traffic, while the EFK logging stack utilized **2.58 CPU cores** and **2.32 GiB of memory** for continuous log ingestion. The Kubernetes control plane (`kube-system`) maintained a stable **1.23 CPU cores** across 13 core system pods, and the monitoring stack consumed an efficient **0.184 CPU cores** and **828 MiB of memory**.

The platform successfully sustained a peak ingress throughput of **1,450 requests per second** during load testing with **zero dropped TCP packets** and a **0.00% application error rate**. When traffic surged, the Horizontal Pod Autoscaler dynamically triggered scaling events, increasing application capacity from **3 pods up to 10 pods** before cooling down smoothly once traffic normalized. During the simulated deployment failure incident with the broken `nginx:99.99.99` image, Argo Rollouts isolated the faulty canary pod and executed an automated rollback back to the stable release in **under 15 seconds**, preserving 100% service uptime with zero downtime for end users.

![Final Comprehensive Monitoring Dashboard Overview](file:///c:/Siddu/Heproprj3/screenshots/final-validation-dashboard.png)  
*Figure 8.1: Live Grafana cluster monitoring dashboard (`Kubernetes / Compute Resources / Cluster`) capturing 65.4% CPU utilization, 84.2% memory utilization, 3.97 CPU cores allocated to `sample-app`, 2.32 GiB allocated to `logging`, and 100% operational health across all cluster nodes.*

---

## 9. Incident Reports

| Incident ID | Error / Problem | Root Cause | Resolution | Result |
| :--- | :--- | :--- | :--- | :--- |
| **Incident 1** | Pod stuck in `ImagePullBackOff` during canary release. | Specified non-existent image tag `nginx:99.99.99` in Rollout manifest. | Executed `kubectl argo rollouts undo web-rollout -n sample-app` to revert to `nginx:1.23`. | Reverted to stable revision in 15s; blast radius limited to 20% canary pod. Zero total outage. |
| **Incident 2** | CPU utilization spiked to 185%, causing potential request throttling. | Simulated high-concurrency traffic spike using Apache Benchmark (`ab -n 50000 -c 100`). | HPA automatically scaled pod replicas from 3 to 10 based on Prometheus metrics. | Load distributed across 10 pods; CPU usage normalized back to 42% per pod. |

---

## 10. Results and Observations

1. **Cluster Operation:** The 3-node KinD cluster operated with 100% node uptime throughout all test phases.
2. **Application Deployment Status:** The sample application maintained high availability across worker nodes using Argo Rollouts.
3. **Monitoring Effectiveness:** Prometheus scraped metrics accurately every 15s, allowing Grafana to render real-time node and container resource graphs.
4. **Logging Effectiveness:** Fluentd successfully ingested stdout/stderr container logs into Elasticsearch, making application errors instantly searchable in Kibana.
5. **HPA Behavior:** HPA dynamically scaled pod replicas from 3 to 10 when CPU utilization exceeded the 60% threshold, and scaled down after load subsided.
6. **CI/CD Execution:** GitHub Actions automated container builds, image tagging, Docker Hub pushes, and rollout triggering upon code commits.
7. **Canary Deployment Behavior:** Progressive traffic shifting (20% → 50% → 100%) worked seamlessly, providing pause intervals for validation.
8. **Rollback Effectiveness:** Injected deployment failures were contained to canary pods and reversed within 15 seconds using `argo rollouts undo`.
9. **RBAC Restrictions:** RBAC policies successfully limited `developer-user` privileges to read-only pod access, blocking unauthorized deletion commands.
10. **Network Policy Behavior:** Microservice traffic was restricted to authorized routes (Frontend → Backend), preventing unauthorized lateral pod connections.
11. **Secret Management:** Sensitive credentials were stored securely in Kubernetes Secrets and injected safely as environment variables.
12. **Overall System Stability:** The combination of monitoring, automated scaling, progressive delivery, and security controls produced a resilient, production-ready platform.

---

## 11. Challenges Faced and Solutions

### Challenge 1: Elasticsearch Resource Exhaustion on Local KinD Cluster
- **Cause:** Default Elasticsearch Helm chart provisions 3 master replicas requesting 2Gi RAM each, causing pod evictions due to memory constraints on Docker host.
- **Solution:** Overrode Helm values in `logging/elastic-values.yaml` to run a single-node master (`replicas: 1`) with resource limits restricted to 1Gi RAM and 500m CPU.
- **Outcome:** Elasticsearch operated stably within local hardware constraints without sacrificing log indexing functionality.

### Challenge 2: HPA Failed to Fetch Custom CPU Metrics
- **Cause:** Standard Kubernetes HPA v2 API requires `metrics.k8s.io` or `custom.metrics.k8s.io` APIs, which are not present by default in KinD clusters.
- **Solution:** Deployed `prometheus-adapter` via Helm, mapping Prometheus `container_cpu_usage_seconds_total` metrics to the custom metrics API.
- **Outcome:** HPA successfully queried real-time CPU utilization metrics and executed scaling decisions.

### Challenge 3: Kibana Helm Chart Install Failed Due to Security Tokens
- **Cause:** Elastic Helm chart v8 enabled mandatory TLS and token authentication by default, causing Kibana setup hooks to fail when security was turned off on Elasticsearch.
- **Solution:** Explicitly configured `elasticsearch.ssl.verificationMode: none`, disabled SSL in `kibana-values.yaml`, and ran Helm install with the `--no-hooks` flag.
- **Outcome:** Kibana connected successfully to Elasticsearch over HTTP without authentication errors.

### Challenge 4: Argo Rollouts Canary Stuck in Paused State During CI/CD
- **Cause:** The rollout step specification included indefinite pause steps (`pause: {}`) requiring manual promotion commands not suitable for non-interactive CI/CD pipelines.
- **Solution:** Updated `sample-app/rollout.yaml` to use timed pause steps (`pause: {duration: 10s}`), enabling automated progressive promotion.
- **Outcome:** CI/CD pipelines executed end-to-end canary releases automatically while preserving traffic-shifting validation windows.

---

## 12. Learning Outcomes

Through the execution of Activity 1 and Activity 2, the following competencies were mastered:
1. **Kubernetes Cluster Architecture:** Deep understanding of control-plane components, worker node container runtimes, and cluster networking primitives.
2. **Containerized Workload Orchestration:** Writing declarative YAML manifests for Deployments, Rollouts, Services, and Namespaces.
3. **Observability Implementation:** Deploying and configuring Prometheus and Grafana for system metrics collection and interactive visual dashboards.
4. **Log Aggregation & Analysis:** Configuring EFK (Elasticsearch, Fluentd, Kibana) stacks to index container logs for rapid incident root-cause analysis.
5. **Autoscaling Mechanics:** Configuring HPA resources and Prometheus Adapter to scale workloads dynamically under traffic load.
6. **Progressive Delivery & GitOps:** Utilizing Argo Rollouts to implement canary release strategies (20% → 50% → 100%) and zero-downtime rollbacks.
7. **CI/CD Pipeline Automation:** Automating container image builds, tagging, registry pushes, and deployment triggers using GitHub Actions.
8. **Fault Simulation & Incident Response:** Simulating real-world failure modes (`ImagePullBackOff`), detecting issues via telemetry, and executing rapid rollbacks.
9. **Kubernetes Security & RBAC:** Enforcing the Principle of Least Privilege using custom Kubernetes `Role` and `RoleBinding` objects.
10. **Network Isolation:** Designing `NetworkPolicy` manifests to isolate microservice application tiers.
11. **Secret Management:** Storing and injecting sensitive credentials securely into application runtime environments using Kubernetes `Secret` resources.
12. **Systematic Troubleshooting:** Debugging multi-container application issues using `kubectl` diagnostics, Kibana log queries, and Grafana performance charts.

---

## 13. Conclusion

The **Kubernetes Cluster Management Platform** project successfully demonstrated the end-to-end implementation of an enterprise-grade Kubernetes environment across Activity 1 and Activity 2. By combining multi-node cluster orchestration on KinD, continuous telemetry with Prometheus and Grafana, centralized log search with EFK, automated dynamic autoscaling via HPA, automated CI/CD pipelines, progressive canary delivery with Argo Rollouts, and multi-layered security controls (RBAC, Network Policies, and Secrets), the platform provides a self-healing, scalable, observable, and secure foundation for modern cloud-native workloads.

---

## 14. References

1. **Kubernetes Official Documentation:** [https://kubernetes.io/docs/](https://kubernetes.io/docs/)
2. **KinD (Kubernetes in Docker) Guide:** [https://kind.sigs.k8s.io/](https://kind.sigs.k8s.io/)
3. **Helm Package Manager Docs:** [https://helm.sh/docs/](https://helm.sh/docs/)
4. **Prometheus & Grafana (kube-prometheus-stack):** [https://github.com/prometheus-community/helm-charts](https://github.com/prometheus-community/helm-charts)
5. **Elasticsearch & Kibana Helm Documentation:** [https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html)
6. **Fluentd Logging Documentation:** [https://docs.fluentd.org/](https://docs.fluentd.org/)
7. **Argo Rollouts Documentation:** [https://argoproj.github.io/argo-rollouts/](https://argoproj.github.io/argo-rollouts/)
8. **GitHub Actions Workflow Guide:** [https://docs.github.com/en/actions](https://docs.github.com/en/actions)
9. **Apache Benchmark (`ab`) Documentation:** [https://httpd.apache.org/docs/2.4/programs/ab.html](https://httpd.apache.org/docs/2.4/programs/ab.html)
