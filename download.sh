#!/bin/sh

UA="eaglercraft-gateway/1.0 (contact: your-email@example.com)"
VERSION="3.5.1"

echo "--- Fetching builds list ---"
HTTP_CODE=$(curl -s -w "%{http_code}" -H "User-Agent: $UA" "https://fill.papermc.io/v3/projects/velocity/versions/$VERSION/builds" -o builds.json)
echo "HTTP STATUS: $HTTP_CODE"
echo "--- Response body ---"
cat builds.json
echo "--- End response ---"

if [ "$HTTP_CODE" != "200" ]; then
    echo "Request failed, stopping."
    exit 1
fi

LATEST_BUILD=$(jq -r 'map(select(.channel == "STABLE")) | .[0] | .id' builds.json)
echo "BUILD: $LATEST_BUILD"

echo "--- Fetching build details ---"
curl -sf -H "User-Agent: $UA" "https://fill.papermc.io/v3/projects/velocity/versions/$VERSION/builds/$LATEST_BUILD" -o build.json
cat build.json

DOWNLOAD_URL=$(jq -r '.downloads."server:default".url' build.json)
echo "URL: $DOWNLOAD_URL"

curl -sf -H "User-Agent: $UA" -o velocity.jar "$DOWNLOAD_URL"
ls -la velocity.jar
