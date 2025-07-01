#!/bin/bash

set -e

ROOT="$(dirname "$(realpath "$0")")"

echo "⬆️  Actualizando todos los servicios docker-compose en subdirectorios de $ROOT ..."

find "$ROOT" -type f -name "docker-compose.yml" | while read -r composefile; do
    dir=$(dirname "$composefile")
    echo "⬆️  Actualizando servicios en: $dir"
    (cd "$dir" && docker compose pull)
    (cd "$dir" && docker compose up -d)
    echo ""
done

echo "✅ Todos los servicios han sido actualizados."
