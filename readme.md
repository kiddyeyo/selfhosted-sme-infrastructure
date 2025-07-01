# Self-Hosted SME Infrastructure

This repository provides a complete self-hosted environment for small and medium businesses, using Docker Compose to run websites, ERPs, monitoring tools, backups, and secure access — all on your own server. Each directory contains a service with its own docker-compose.yml and .env.example, making setup modular and easy.

---

## Stack Components

| Service | Purpose |
|---------|---------|
| **Traefik** | Reverse proxy that routes incoming requests to the appropriate containers and automatically issues TLS certificates via Cloudflare. |
| **Cloudflared** | Maintains a secure tunnel to Cloudflare so that the services can be reached from the internet without exposing the host directly. |
| **WordPress** | Content management system for your website or blog. Uses **MariaDB** for its database. |
| **Odoo** | Open source ERP/CRM platform running with **PostgreSQL** as its backend. |
| **Adminer** | Lightweight web interface to manage the MariaDB and PostgreSQL databases. |
| **Portainer** | Web GUI for Docker that simplifies container management. |
| **Authentik** | Provides single sign-on (SSO) and authentication for the different applications. |
| **Checkmate** | Monitors uptime and performance of your services using **MongoDB** and **Redis** internally. |
| **Netdata** | Collects real-time metrics from the host and containers for monitoring. |
| **Diun** | Watches Docker images and notifies you when updates are available. |
| **Restic** | Performs scheduled backups of databases and volumes and can send notifications to Discord. |
| **MariaDB** | Database engine used by WordPress. |
| **PostgreSQL** | Database engine used by Odoo and Authentik. |

Every directory that contains a `docker-compose.yml` also provides a `.env.example` file describing the variables needed by that service. Copy these files to `.env` and adjust their values to match your domain names, credentials and tokens.

The sample configuration files use `example.com` as the placeholder domain. Replace it with your own domain when deploying.

---

## Requirements

- Docker and Docker Compose installed on your server
- DNS records pointing to the host
- A Cloudflare account for the tunnel and TLS certificates

---

## Quick Start

```bash
git clone https://github.com/kiddyeyo/stack-empresarial ~/infraestructura
cd ~/infraestructura
./init.sh    # generate .env files, configs, network and volumes
# edit the created .env files with your passwords and domain names
```

## Authentik setup

Before exposing services to the internet, deploy Authentik locally and configure your identity provider settings. If you're running locally or not using Cloudflare Zero Trust, you may skip this step.

```bash
cd ~/infraestructura/traefik
docker compose up -d
```

Then

```bash
cd ..
cd authentik
docker compose up -d
```

Check that the service is up and running

```bash
docker ps
docker compose logs -f
```

Make your authentik admin user and configure your users. In cloudflare you should make authentik your identity provider and put the apps and services you need behind it.

## Firewall and Backups

If you use UFW, open the following ports so Traefik can route to Netdata:

```bash
sudo ufw allow from 172.18.0.0/16 to any port 19999   
sudo ufw enable
```

Backups are handled by the Restic containers. They run on a schedule defined in their environment variables and can be customized by editing `crontab -e` or the Restic `.env` file.

## Persistent Data: Databases and Config Files

All databases, configuration files, and backups are stored in named Docker volumes for durability and easy backup. These volumes are created automatically by the init.sh script and are used by the relevant containers (e.g. MariaDB, PostgreSQL, MongoDB, Redis, WordPress, Odoo, Authentik, etc).

You can view all Docker volumes in use with:

docker volume ls

To perform manual or automated backups, use the Restic container, which is preconfigured to back up all critical volumes.

## Deploy all containers

```bash
./up_all.sh
```

All containers will start in the background. Use `docker ps` to see their status and `docker logs <service>` to view logs.

---

## Management Scripts

- `./init.sh` &ndash; prepare configuration files, network and volumes
- `./up_all.sh` &ndash; start every service
- `./down_all.sh` &ndash; stop all services
- `./restart_all.sh` &ndash; restart the entire stack
- `./update_all.sh` &ndash; pull newer images and recreate containers

---

### License

This project is licensed under the MIT License. You are free to use, modify, and distribute it for personal, educational, or commercial purposes. See LICENSE for more details.

---
