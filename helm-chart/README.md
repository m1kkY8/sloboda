# Sloboda Stack Helm Chart

This Helm chart deploys the Sloboda infrastructure stack on Kubernetes with Traefik as the ingress controller.

## Prerequisites

- Kubernetes cluster (K3s recommended for single-node)
- Helm 3.x
- kubectl configured to access your cluster
- DNS records pointing to your cluster's external IP

## Services Included

- **Portainer** - Container management UI
- **Traefik** - Reverse proxy and ingress controller with automatic SSL
- **Trilium** - Note-taking application
- **Grafana** - Monitoring and visualization
- **Prometheus** - Metrics collection and monitoring
- **Node Exporter** - System metrics exporter
- **Jenkins** - CI/CD automation server
- **Matrix Synapse** - Decentralized chat server

## Installation

### 1. Add Traefik Helm Repository

```bash
helm repo add traefik https://traefik.github.io/charts
helm repo update
```

### 2. Install the Chart

```bash
# Install with default values
helm install sloboda-stack ./helm-chart

# Or install with custom values
helm install sloboda-stack ./helm-chart -f custom-values.yaml

# Install in specific namespace
kubectl create namespace sloboda
helm install sloboda-stack ./helm-chart -n sloboda
```

### 3. Update DNS Records

Point the following domains to your K3s cluster's external IP:
- `portainer.slobodausisivac.rocks`
- `notes.slobodausisivac.rocks`
- `grafana.slobodausisivac.rocks`
- `prometheus.slobodausisivac.rocks`
- `jenkins.slobodausisivac.rocks`
- `matrix.slobodausisivac.rocks`

## Configuration

### Custom Values Example

Create a `custom-values.yaml` file:

```yaml
global:
  domain: your-domain.com
  
grafana:
  env:
    GF_SECURITY_ADMIN_PASSWORD: "your-secure-password"

trilium:
  ingress:
    host: notes.your-domain.com

# Disable services you don't need
matrix:
  enabled: false
```

### Storage Configuration

By default, the chart uses K3s's `local-path` storage class. For production, consider using a more robust storage solution:

```yaml
global:
  storageClass: longhorn  # or your preferred storage class

prometheus:
  persistence:
    size: 20Gi

grafana:
  persistence:
    size: 5Gi
```

## Upgrading

```bash
helm upgrade sloboda-stack ./helm-chart
```

## Uninstalling

```bash
helm uninstall sloboda-stack
```

## Accessing Services

After installation, services will be available at:
- Portainer: https://portainer.slobodausisivac.rocks
- Trilium: https://notes.slobodausisivac.rocks
- Grafana: https://grafana.slobodausisivac.rocks
- Prometheus: https://prometheus.slobodausisivac.rocks
- Jenkins: https://jenkins.slobodausisivac.rocks
- Matrix: https://matrix.slobodausisivac.rocks

### Default Credentials

- **Grafana**: admin / admin123 (change this!)
- **Portainer**: Set up during first access
- **Jenkins**: Get initial password with:
  ```bash
  kubectl logs deployment/sloboda-stack-jenkins | grep -A 3 "Jenkins initial setup"
  ```

## Monitoring

The chart includes a complete monitoring stack:
- Prometheus scrapes metrics from all services
- Node Exporter provides system metrics
- Grafana provides dashboards (configure Prometheus datasource: `http://sloboda-stack-prometheus:9090`)

## Troubleshooting

### Check Pod Status
```bash
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Check Ingress
```bash
kubectl get ingress
kubectl describe ingress <ingress-name>
```

### Check Traefik Dashboard
```bash
kubectl port-forward svc/sloboda-stack-traefik 8080:8080
# Visit http://localhost:8080
```

### SSL Certificate Issues
```bash
kubectl get certificaterequests
kubectl describe certificaterequest <name>
```

## Security Considerations

1. **Change default passwords** immediately after installation
2. **Use strong passwords** for all services
3. **Configure proper RBAC** if needed
4. **Enable network policies** for additional security
5. **Regularly update images** and chart versions

## K3s Specific Notes

- K3s comes with Traefik v1 by default. This chart installs Traefik v3.
- To disable the built-in Traefik: `curl -sfL https://get.k3s.io | sh -s - --disable traefik`
- K3s uses `local-path` as the default storage class
- LoadBalancer services use the node's IP by default in K3s

## Persistence

All services are configured with persistent storage by default. Data will survive pod restarts but ensure you have proper backup strategies for production use.
