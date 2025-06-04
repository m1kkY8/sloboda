# Selfhosted wiki and notes stack

## Services
- **[Wiki.js](https://js.wiki/)** – Powerful and extensible wiki engine
- **[Trilium Notes](https://github.com/TriliumNext/Notes)** – Hierarchical note-taking app with synchronization
- **[WireGuard](https://www.wireguard.com/)** - WireGuard VPN server

## Monitoring
- **[Prometheus](https://prometheus.io/docs/introduction/overview/)** - Data collection 
- **[Grafana](https://grafana.com/)** - Grafana for dashboards

- All services are managed with `docker compose`

# Requirements

- Domain; i got mine on [Name.com](https://www.name.com/)
- VPS or any other kind of public facing server; for this i use [Hetzner](https://www.hetzner.com/)

## Setting up
1. Create a server 
2. Add create all DNS entries 
3. Configure server and install docker 
4. Clone repo and populate .env file
5. `docker compose up -d`