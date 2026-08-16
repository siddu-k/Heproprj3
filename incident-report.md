# INCIDENT REPORT

**Date:** August 3, 2026  
**Reported by:** [Your Name]  
**Severity:** Medium  

---

## 1. Summary

A faulty container image (`nginx:99.99.99`) was deployed via Argo Rollouts canary strategy, causing new pods to enter `ImagePullBackOff` state. The canary strategy limited the blast radius to 20% of traffic.

## 2. Timeline

| Time | Event |
|------|-------|
| T+0s | Canary rollout initiated with image `nginx:99.99.99` |
| T+15s | New canary pod fails to pull image — `ImagePullBackOff` |
| T+20s | Canary rollout paused at 20% weight — only failed pods receive traffic |
| T+30s | Incident detected via `kubectl get pods` — unhealthy pod identified |
| T+45s | Rollback initiated with `kubectl argo rollouts undo` |
| T+60s | Rollback complete — stable version `nginx:1.23` restored |

## 3. Root Cause

The specified image tag `nginx:99.99.99` does not exist in Docker Hub, causing the container runtime to fail the image pull. This simulates a scenario where a broken or unvalidated image is pushed to production.

## 4. Impact

- **Limited impact** due to canary strategy — only 20% of traffic was affected
- No data loss occurred
- Service was partially degraded for approximately 30 seconds
- Remaining 80% of traffic continued to be served by stable pods

## 5. Detection

- Detected via Kubernetes pod status monitoring (`ImagePullBackOff`)
- Grafana dashboards showed pod restart count increase in the `sample-app` namespace
- Kibana logs captured image pull failure errors from the container runtime
- Argo Rollouts dashboard showed canary stuck at 20%

## 6. Resolution

1. Identified failing pods using `kubectl get pods -n sample-app`
2. Confirmed root cause with `kubectl describe pod` — `ImagePullBackOff` error
3. Initiated rollback using `kubectl argo rollouts undo web-rollout -n sample-app`
4. Verified recovery — all pods returned to `Running` state with image `nginx:1.23`

## 7. Lessons Learned

- Canary deployment strategy **successfully limited the blast radius** — only 20% of traffic was impacted instead of 100%
- The pause step in the canary strategy provided a window for manual detection and intervention
- Health probes (liveness/readiness) correctly marked the failing pod as unhealthy
- Monitoring stack (Prometheus + Grafana) provided visibility into the failure

## 8. Preventive Measures

| Action | Priority | Owner |
|--------|----------|-------|
| Add image existence validation in CI/CD pipeline | High | DevOps |
| Configure Argo Rollouts `AnalysisRun` for automated rollback on health check failures | High | DevOps |
| Set up Prometheus alert rule for `kube_pod_container_status_waiting_reason{reason="ImagePullBackOff"} > 0` | Medium | SRE |
| Implement image signing and verification (e.g., Cosign) | Medium | Security |
| Add pre-deployment smoke tests in staging environment | Low | QA |

---

## Screenshots

> Add screenshots in the `screenshots/` folder and reference them here:
> 
> - `screenshots/incident-failed-deploy.png` — Pods in ImagePullBackOff state
> - `screenshots/incident-rollback.png` — Successful rollback to stable version
> - `screenshots/grafana-incident.png` — Grafana showing pod restart spike
