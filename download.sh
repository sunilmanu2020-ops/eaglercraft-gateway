#!/bin/sh
set -e

UA="eaglercraft-gateway/1.0 (contact: your-email@example.com)"
VERSION="3.5.1"

echo "--- Fetching builds list ---"
curl -sf -H "User-Agent: $UA" "https://fill.papermc.io/v3/projects/velocity/versions/$VERSION/builds" -o builds.json
cat builds.json

LATEST_BUILD=$(jq -r 'map(select(.channel == "STABLE")) | .[0] | .id' builds.json)
echo "BUILD: $LATEST_BUILD"

echo "--- Fetching build details ---"
curl -sf -H "User-Agent: $UA" "https://fill.papermc.io/v3/projects/velocity/versions/$VERSION/builds/$LATEST_BUILD" -o build.json
cat build.json

DOWNLOAD_URL=$(jq -r '.downloads."server:default".url' build.json)
echo "URL: $DOWNLOAD_URL"

curl -sf -H "User-Agent: $UA" -o velocity.jar "$DOWNLOAD_URL"
ls -la velocity.jar
