# Use Eclipse Temurin Java 21 as the base image (most popular open-source JRE)
FROM eclipse-temurin:21-jre

# Set build arguments for flexibility
ARG JAR_FILE=app.jar
ARG APP_JAR_NAME=app.jar
ARG APP_USER_UID=10001
ARG APP_USER_GID=10001

# Set the working directory
WORKDIR /app

# Copy the built jar file into the container using the build argument
COPY ${JAR_FILE} /app/${APP_JAR_NAME}

# Expose the default Spring Boot port
EXPOSE 8080

# Create a non-root user and group with configurable UID/GID
RUN addgroup --gid ${APP_USER_GID} springgroup && \
    adduser --disabled-password --gecos '' --uid ${APP_USER_UID} --gid ${APP_USER_GID} springuser
USER springuser

# Allow passing JVM options via environment variable JVM_OPTS
ENV JVM_OPTS=""

# Add image metadata
LABEL org.opencontainers.image.source="https://github.com/<your-repo>"

# Support for custom entrypoint or command, JVM options, and app args
ENTRYPOINT ["sh", "-c", "exec java $JVM_OPTS -jar /app/${APP_JAR_NAME} $@", "--"]

# Example: To pass environment variables, use -e when running the container
# docker run -e SPRING_PROFILES_ACTIVE=prod -e CUSTOM_ENV=foo -p 8080:8080 <image>
# To pass app arguments: docker run <image> --spring.config.location=/app/config/
