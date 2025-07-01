#!/bin/bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy all .env.example files to .env if missing
find "$ROOT" -name '.env.example' | while read -r example; do
  target="${example%.example}"
  if [ ! -f "$target" ]; then
    cp "$example" "$target"
    echo "Copied $(basename "$example") to $(basename "$target")"
  fi
done

# Additional configuration files
if [ -f "$ROOT/odoo/odoo.conf.ejemplo" ] && [ ! -f "$ROOT/odoo/odoo.conf" ]; then
  cp "$ROOT/odoo/odoo.conf.ejemplo" "$ROOT/odoo/odoo.conf"
  echo "Created odoo/odoo.conf"
fi

if [ -f "$ROOT/traefik/config/traefik.template.yml" ]; then
  if [ ! -f "$ROOT/traefik/config/traefik.yml" ]; then
    cp "$ROOT/traefik/config/traefik.template.yml" "$ROOT/traefik/config/traefik.yml"
    echo "Created traefik/config/traefik.yml"
  fi
  if [ ! -f "$ROOT/traefik/config/dynamic.yml" ]; then
    cp "$ROOT/traefik/config/dynamic.template.yml" "$ROOT/traefik/config/dynamic.yml"
    echo "Created traefik/config/dynamic.yml"
  fi
fi

if [ ! -f "$ROOT/traefik/config/acme.json" ]; then
  touch "$ROOT/traefik/config/acme.json"
  chmod 600 "$ROOT/traefik/config/acme.json"
  echo "Created traefik/config/acme.json"
fi

# Create empty file for Cloudflare API token (for DNS zone editing / TLS certificates)
if [ ! -f "$ROOT/traefik/config/cf-token" ]; then
  touch "$ROOT/traefik/config/cf-token"
  chmod 600 "$ROOT/traefik/config/cf-token"
  echo "Created traefik/config/cf-token (put your Cloudflare API token here)"
fi

# Docker network
if ! docker network inspect infraestructura_app-network >/dev/null 2>&1; then
  docker network create infraestructura_app-network
fi

# Docker volumes
VOLUMES=(
  authentik_postgres_data
  authentik_redis_data
  checkmate_mongo_data
  checkmate_mongo_config
  checkmate_redis_data
  diun_data
  netdatalib
  netdatacache
  odoo_data
  odoo_postgres_data
  portainer_data
  wordpress_data
  wordpress_mariadb_data
  wordpress_redis_data
)

for vol in "${VOLUMES[@]}"; do
  if ! docker volume inspect "$vol" >/dev/null 2>&1; then
    docker volume create "$vol" >/dev/null
  fi
done

echo "Initialization complete."
