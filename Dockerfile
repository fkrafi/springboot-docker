# Use Eclipse Temurin Java 21 as the base image (most popular open-source JRE)
FROM eclipse-temurin:21-jre

# Set build arguments for flexibility
ARG APP_USER_UID=10001
ARG APP_USER_GID=10001

# Set the working directory
WORKDIR /app

# Expose the default Spring Boot port
EXPOSE 8080

# Create a non-root user and group with configurable UID/GID
RUN addgroup --gid ${APP_USER_GID} springgroup && \
    adduser --disabled-password --gecos '' --uid ${APP_USER_UID} --gid ${APP_USER_GID} springuser
USER springuser

# Allow passing JVM options via environment variable JVM_OPTS
ENV JVM_OPTS=""

# Allow passing the JAR file name at runtime via an environment variable (APP_JAR)
ENV APP_JAR="app.jar"

# Allow passing the application name at runtime via an environment variable (APP_NAME)
ENV APP_NAME="springboot-app"

# Support for custom entrypoint or command, JVM options, app name, and app args
ENTRYPOINT ["sh", "-c", "exec java $JVM_OPTS -jar $APP_JAR --spring.application.name=$APP_NAME $@", "--"]

# Example: To pass environment variables, use -e when running the container
# docker run -e SPRING_PROFILES_ACTIVE=prod -e CUSTOM_ENV=foo -p 8080:8080 <image>
# To pass app arguments: docker run <image> --spring.config.location=/app/config/
