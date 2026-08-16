# Kubernetes Cluster Management Platform

A production-oriented Kubernetes environment running on **KinD** (Kubernetes in Docker) with full observability, autoscaling, and progressive delivery capabilities.

## Architecture

```
┌──────────────────────────────────────────────────┐
│                  KinD Cluster                    │
│              (1 control-plane + 2 workers)       │
│                                                  │
│  ┌──────────────┐  ┌────────────────────────┐    │
│  │  monitoring   │  │       logging          │    │
│  │  Prometheus   │  │  Elasticsearch (EFK)   │    │
│  │  Grafana      │  │  Fluentd               │    │
│  │  Prom Adapter │  │  Kibana                │    │
│  └──────────────┘  └────────────────────────┘    │
│                                                  │
│  ┌──────────────┐  ┌────────────────────────┐    │
│  │ argo-rollouts │  │     sample-app         │    │
│  │  Controller   │  │  Rollout (canary)      │    │
│  │              │  │  Service + HPA          │    │
│  └──────────────┘  └────────────────────────┘    │
└──────────────────────────────────────────────────┘
```

## Prerequisites

Make sure the following tools are installed:

| Tool | Version | Install |
|------|---------|---------|
| Docker | 20.10+ | [docs.docker.com](https://docs.docker.com/get-docker/) |
| kind | 0.20+ | `go install sigs.k8s.io/kind@latest` |
| kubectl | 1.27+ | [kubernetes.io](https://kubernetes.io/docs/tasks/tools/) |
| Helm | 3.12+ | [helm.sh](https://helm.sh/docs/intro/install/) |

## Quick Start

Run the scripts **in order** from the project root:

```bash
# 1. Create the KinD cluster (1 control-plane + 2 workers)
bash scripts/01-create-cluster.sh

# 2. Install Prometheus & Grafana for monitoring
bash scripts/02-install-monitoring.sh

# 3. Install EFK stack (Elasticsearch, Fluentd, Kibana) for logging
bash scripts/03-install-logging.sh

# 4. Install Prometheus Adapter for custom HPA metrics
bash scripts/04-install-hpa.sh

# 5. Install Argo Rollouts for canary deployments
bash scripts/05-install-rollouts.sh

# 6. Deploy the sample nginx app with canary rollout + HPA
bash scripts/06-deploy-sample.sh
```

## Project Structure

```
├── cluster/
│   └── kind-config.yaml            # KinD cluster topology
├── monitoring/
│   └── prometheus-values.yaml      # Prometheus + Grafana Helm values
├── logging/
│   ├── elastic-values.yaml         # Elasticsearch Helm values
│   ├── fluentd-values.yaml         # Fluentd Helm values
│   └── kibana-values.yaml          # Kibana Helm values
├── hpa/
│   └── prometheus-adapter-values.yaml  # Prometheus Adapter config
├── sample-app/
│   ├── rollout.yaml                # Argo Rollout (canary strategy)
│   ├── service.yaml                # ClusterIP Service
│   └── hpa.yaml                    # HorizontalPodAutoscaler
├── scripts/
│   ├── 01-create-cluster.sh        # Cluster provisioning
│   ├── 02-install-monitoring.sh    # Prometheus + Grafana
│   ├── 03-install-logging.sh       # EFK stack
│   ├── 04-install-hpa.sh           # Prometheus Adapter
│   ├── 05-install-rollouts.sh      # Argo Rollouts controller
│   └── 06-deploy-sample.sh         # Sample app deployment
└── README.md
```

## Accessing Dashboards

After deployment, use `kubectl port-forward` to access the UIs:

```bash
# Grafana (monitoring)
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
# → Open http://localhost:3000 (user: admin)
# If port 3000 is taken, use an alternate port:
#   kubectl port-forward svc/monitoring-grafana -n monitoring 3001:80

# Kibana (logging)
kubectl port-forward svc/kibana-kibana -n logging 5601:5601
# → Open http://localhost:5601
# If port 5601 is taken:
#   kubectl port-forward svc/kibana-kibana -n logging 5602:5601

# Argo Rollouts Dashboard
kubectl argo rollouts dashboard -n sample-app
# → Open http://localhost:3100
```

## Canary Deployment Strategy

The sample app uses a **canary rollout** strategy:

1. **20%** of traffic shifted → 10s pause
2. **50%** of traffic shifted → 10s pause
3. **100%** promotion (automatic)

To update the app image and trigger a canary rollout:

```bash
kubectl argo rollouts set image web-rollout web=nginx:1.24 -n sample-app
kubectl argo rollouts get rollout web-rollout -n sample-app --watch
```

## Cleanup

```bash
kind delete cluster --name k8s-management
```

## Notes

- **Elasticsearch** runs with a single replica — suitable for dev/demo only. Scale up for production.
- **Grafana credentials** are set in `monitoring/prometheus-values.yaml`. For production, use Kubernetes Secrets.
- **HPA** is configured to scale between 3–10 pods based on CPU utilization (target: 60%).
