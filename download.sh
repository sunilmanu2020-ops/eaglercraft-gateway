#!/bin/sh

UA="eaglercraft-gateway/1.0 (contact: your-email@example.com)"
VERSION="3.5.1"

echo "--- Fetching builds list ---"
curl -sf -H "User-Agent: $UA" "https://fill.papermc.io/v3/projects/velocity/versions/$VERSION/builds" -o builds.json
cat builds.json

DOWNLOAD_URL=$(jq -r '.[0].downloads."server:default".url' builds.json)
echo "URL: $DOWNLOAD_URL"

curl -sf -H "User-Agent: $UA" -o velocity.jar "$DOWNLOAD_URL"
ls -la velocity.jar
