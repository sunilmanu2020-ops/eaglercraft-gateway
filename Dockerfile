FROM eclipse-temurin:17-jre

WORKDIR /server

RUN apt-get update && apt-get install -y curl jq

RUN UA="eaglercraft-gateway/1.0 (contact: your-email@example.com)" && \
    LATEST_VERSION=$(curl -s -H "User-Agent: $UA" https://fill.papermc.io/v3/projects/velocity | jq -r '.versions | to_entries[0] | .value[0]') && \
    echo "VERSION: $LATEST_VERSION" && \
    LATEST_BUILD=$(curl -s -H "User-Agent: $UA" https://fill.papermc.io/v3/projects/velocity/versions/$LATEST_VERSION/builds | jq -r 'map(select(.channel == "STABLE")) | .[0] | .id') && \
    echo "BUILD: $LATEST_BUILD" && \
    DOWNLOAD_URL=$(curl -s -H "User-Agent: $UA" https://fill.papermc.io/v3/projects/velocity/versions/$LATEST_VERSION/builds/$LATEST_BUILD | jq -r '.downloads."server:default".url') && \
    echo "URL: $DOWNLOAD_URL" && \
    curl -f -H "User-Agent: $UA" -o velocity.jar "$DOWNLOAD_URL" && \
    ls -la velocity.jar

RUN mkdir -p plugins && \
    curl -fL -o plugins/EaglerXServer.jar https://github.com/lax1dude/eaglerxserver/releases/latest/download/EaglerXServer.jar && \
    ls -la plugins/EaglerXServer.jar

COPY velocity.toml /server/velocity.toml
COPY eula.txt /server/eula.txt

EXPOSE 8080

CMD ["java", "-jar", "velocity.jar"]
