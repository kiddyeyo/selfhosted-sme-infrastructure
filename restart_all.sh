#!/bin/bash

set -e

ROOT="$(dirname "$(realpath "$0")")"

echo "♻️  Reiniciando todos los servicios docker-compose en subdirectorios de $ROOT ..."

find "$ROOT" -type f -name "docker-compose.yml" | while read -r composefile; do
    dir=$(dirname "$composefile")
    echo ""
    echo "⏬ Deteniendo servicios en: $dir"
    (cd "$dir" && docker compose down)
    echo "⏫ Levantando servicios en: $dir"
    (cd "$dir" && docker compose up -d)
done

echo ""
echo "✅ Todos los servicios han sido reiniciados."
