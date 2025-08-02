#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Sloboda Stack Deployment Script${NC}"
echo "================================="

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}kubectl is not installed or not in PATH${NC}"
    exit 1
fi

# Check if helm is available
if ! command -v helm &> /dev/null; then
    echo -e "${RED}helm is not installed or not in PATH${NC}"
    exit 1
fi

# Check cluster connection
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}Cannot connect to Kubernetes cluster${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites check passed${NC}"

# Variables
NAMESPACE=${NAMESPACE:-default}
RELEASE_NAME=${RELEASE_NAME:-sloboda-stack}
CHART_PATH="./helm-chart"

echo "Release Name: $RELEASE_NAME"
echo "Namespace: $NAMESPACE"
echo "Chart Path: $CHART_PATH"

# Create namespace if it doesn't exist
if [ "$NAMESPACE" != "default" ]; then
    echo -e "${YELLOW}Creating namespace $NAMESPACE...${NC}"
    kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
fi

# Add Traefik repository
echo -e "${YELLOW}Adding Traefik Helm repository...${NC}"
helm repo add traefik https://traefik.github.io/charts
helm repo update

# Check if release already exists
if helm list -n $NAMESPACE | grep -q $RELEASE_NAME; then
    echo -e "${YELLOW}Release $RELEASE_NAME already exists. Upgrading...${NC}"
    helm upgrade $RELEASE_NAME $CHART_PATH -n $NAMESPACE
else
    echo -e "${YELLOW}Installing release $RELEASE_NAME...${NC}"
    helm install $RELEASE_NAME $CHART_PATH -n $NAMESPACE
fi

echo -e "${GREEN}✓ Deployment completed successfully!${NC}"

# Wait for pods to be ready
echo -e "${YELLOW}Waiting for pods to be ready...${NC}"
kubectl wait --for=condition=ready pod -l "app.kubernetes.io/instance=$RELEASE_NAME" -n $NAMESPACE --timeout=300s

echo -e "${GREEN}✓ All pods are ready!${NC}"

# Show status
echo -e "${YELLOW}Deployment Status:${NC}"
kubectl get pods -n $NAMESPACE -l "app.kubernetes.io/instance=$RELEASE_NAME"

echo -e "${YELLOW}Ingress Status:${NC}"
kubectl get ingress -n $NAMESPACE

echo -e "${GREEN}Deployment completed! Check the NOTES for accessing your services.${NC}"
helm get notes $RELEASE_NAME -n $NAMESPACE
