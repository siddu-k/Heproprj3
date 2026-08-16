#!/bin/bash
set -e
echo "Installing Prometheus Adapter..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus-adapter prometheus-community/prometheus-adapter --namespace monitoring -f hpa/prometheus-adapter-values.yaml
