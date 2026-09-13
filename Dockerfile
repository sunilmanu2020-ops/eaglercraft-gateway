FROM eclipse-temurin:17-jre

WORKDIR /server

# Download Velocity proxy
RUN apt-get update && apt-get install -y curl && \
    curl -o velocity.jar https://api.papermc.io/v2/projects/velocity/versions/3.3.0-SNAPSHOT/builds/latest/downloads/velocity-3.3.0-SNAPSHOT-all.jar

# Download EaglerXServer plugin
RUN mkdir -p plugins && \
    curl -L -o plugins/EaglerXServer.jar https://github.com/lax1dude/eaglerxserver/releases/latest/download/EaglerXServer.jar

# Copy our config files in (we'll add these next)
COPY velocity.toml /server/velocity.toml
COPY eula.txt /server/eula.txt

EXPOSE 8080

CMD ["java", "-jar", "velocity.jar"]
