#!/bin/bash
set -e
echo "Creating kind cluster..."
kind create cluster --name k8s-management --config cluster/kind-config.yaml || true
echo "Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s
