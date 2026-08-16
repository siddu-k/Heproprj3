#!/bin/bash
set -e
echo "Deploying Sample App..."
kubectl create namespace sample-app || true
kubectl apply -f sample-app/rollout.yaml
kubectl apply -f sample-app/service.yaml
kubectl apply -f sample-app/hpa.yaml
echo "Waiting for rollout to be ready..."
kubectl -n sample-app wait --for=condition=Available rollout/web-rollout --timeout=120s || echo "Rollout still progressing (canary steps in progress)"
echo "Sample app deployed successfully."
