#!/bin/bash

set -e

ROOT="$(dirname "$(realpath "$0")")"

echo "⏫ Levantando todos los servicios docker-compose en subdirectorios de $ROOT ..."

find "$ROOT" -type f -name "docker-compose.yml" | while read -r composefile; do
    dir=$(dirname "$composefile")
    echo "⏫ Levantando servicios en: $dir"
    (cd "$dir" && docker compose up -d)
done

echo "✅ Todos los servicios han sido levantados."
