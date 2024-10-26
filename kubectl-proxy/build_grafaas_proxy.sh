#!/bin/bash

IMAGE_NAME="jjhwan7099/grafaas:latest"

echo "NAME: CLUSTER-IP: PORT/PROTOCOL" > ./grafaas-proxy/k8s_services_info
kubectl get svc --all-namespaces -o jsonpath='{range .items[*]}{.metadata.name}: {.spec.clusterIP}: {range .spec.ports[*]}{.port}/{.protocol} {" "}{end}{"\n"}{end}' >> ./grafaas-proxy/k8s_services_info

# Build the Docker image
docker build --network=host -t  $IMAGE_NAME ./grafaas-proxy/. || { echo "Docker build failed"; exit 1; }

# Push the Docker image
docker push $IMAGE_NAME || { echo "Docker push failed"; exit 1; }

rm ./grafaas-proxy/k8s_services_info

# Kubernetes service start
kubectl apply -f ./grafaas-proxy/nginx-configmap.yaml -n openfaas || { echo "Failed to apply nginx-configmap"; exit 1; }
kubectl apply -f ./grafaas-proxy/nginx-deployment.yaml -n openfaas || { echo "Failed to apply nginx-deployment"; exit 1; }
kubectl apply -f ./grafaas-proxy/nginx-service.yaml -n openfaas || { echo "Failed to apply nginx-service"; exit 1; }