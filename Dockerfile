FROM eclipse-temurin:17-jre

WORKDIR /server

RUN apt-get update && apt-get install -y curl jq

RUN LATEST_VERSION=$(curl -s https://api.papermc.io/v2/projects/velocity | jq -r '.versions[-1]') && \
    echo "VERSION: $LATEST_VERSION" && \
    LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/velocity/versions/$LATEST_VERSION/builds | jq -r '.builds[-1].build') && \
    echo "BUILD: $LATEST_BUILD" && \
    URL="https://api.papermc.io/v2/projects/velocity/versions/$LATEST_VERSION/builds/$LATEST_BUILD/downloads/velocity-$LATEST_VERSION-$LATEST_BUILD.jar" && \
    echo "URL: $URL" && \
    curl -f -o velocity.jar "$URL" && \
    ls -la velocity.jar

RUN mkdir -p plugins && \
    curl -fL -o plugins/EaglerXServer.jar https://github.com/lax1dude/eaglerxserver/releases/latest/download/EaglerXServer.jar && \
    ls -la plugins/EaglerXServer.jar

COPY velocity.toml /server/velocity.toml
COPY eula.txt /server/eula.txt

EXPOSE 8080

CMD ["java", "-jar", "velocity.jar"]
