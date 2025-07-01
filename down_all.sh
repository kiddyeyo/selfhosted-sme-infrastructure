#!/bin/bash

set -e

ROOT="$(dirname "$(realpath "$0")")"

echo "🛑 Bajando todos los servicios docker-compose en subdirectorios de $ROOT ..."

find "$ROOT" -type f -name "docker-compose.yml" | while read -r composefile; do
    dir=$(dirname "$composefile")
    echo "⏬ Deteniendo servicios en: $dir"
    (cd "$dir" && docker compose down)
done

echo "✅ Todos los servicios están abajo."
