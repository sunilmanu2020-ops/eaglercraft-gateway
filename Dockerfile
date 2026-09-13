FROM eclipse-temurin:21-jre

WORKDIR /server

RUN apt-get update && apt-get install -y curl jq

RUN UA="eaglercraft-gateway/1.0 (contact: your-email@example.com)" && \
    VERSION="3.5.1" && \
    echo "--- Fetching builds list ---" && \
    curl -sf -H "User-Agent: $UA" "https://fill.papermc.io/v3/projects/velocity/versions/$VERSION/builds" -o builds.json && \
    cat builds.json && \
    LATEST_BUILD=$(jq -r 'map(select(.channel == "STABLE")) | .[0] | .id' builds.json) && \
    echo "BUILD: $LATEST_BUILD" && \
    test "$LATEST_BUILD" != "null" && \
    echo "--- Fetching build details ---" && \
    curl -sf -H "User-Agent: $UA" "https://fill.papermc.io/v3/projects/velocity/versions/$VERSION/builds/$LATEST_BUILD" -o build.json && \
