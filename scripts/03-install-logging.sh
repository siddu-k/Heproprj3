#!/bin/bash
set -e
echo "Installing EFK stack..."
helm repo add elastic https://helm.elastic.co
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update

# Install Elasticsearch (security disabled for dev)
helm upgrade --install elasticsearch elastic/elasticsearch -f logging/elastic-values.yaml --namespace logging --create-namespace

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch..."
kubectl rollout status statefulset/elasticsearch-master -n logging --timeout=180s

# Create dummy token secret (Kibana chart expects it, but we disabled ES security)
kubectl create secret generic kibana-kibana-es-token --from-literal=token='' -n logging 2>/dev/null || true

# Install Kibana (skip pre-install hook — ES security is disabled)
helm upgrade --install kibana elastic/kibana -f logging/kibana-values.yaml --namespace logging --no-hooks

# Install Fluentd
helm upgrade --install fluentd fluent/fluentd -f logging/fluentd-values.yaml --namespace logging
