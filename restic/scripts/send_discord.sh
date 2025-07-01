#!/usr/bin/env bash

if [ -z "$DISCORD_WEBHOOK_URL" ]; then
  echo "ERROR: No se encontró la variable DISCORD_WEBHOOK_URL."
  exit 1
fi

MESSAGE="$*"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

PAYLOAD=$(cat <<EOM
{
  "content": "${MESSAGE} a las ${TIMESTAMP}"
}
EOM
)

curl -s -H "Content-Type: application/json" \
  -X POST \
  -d "$PAYLOAD" \
  "$DISCORD_WEBHOOK_URL"

