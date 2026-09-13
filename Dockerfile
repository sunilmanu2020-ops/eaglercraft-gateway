FROM eclipse-temurin:21-jre

WORKDIR /server

RUN apt-get update && apt-get install -y curl jq

COPY download.sh /server/download.sh
RUN chmod +x /server/download.sh && /server/download.sh

RUN mkdir -p plugins && \
    curl -fL -o plugins/EaglerXServer.jar https://github.com/lax1dude/eaglerxserver/releases/latest/download/EaglerXServer.jar && \
    ls -la plugins/EaglerXServer.jar

COPY velocity.toml /server/velocity.toml
COPY eula.txt /server/eula.txt

EXPOSE 8080

CMD ["java", "-jar", "velocity.jar"]
