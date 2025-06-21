# Spring Boot Java 21 Docker Image

A minimal, production-ready Docker image for running any Spring Boot application built with Java 21. This image is designed to be generic and reusable for any Spring Boot JAR file.

---

## Features
- Based on the official Eclipse Temurin Java 21 JRE image
- Supports passing environment variables to your Spring Boot app
- Exposes port 8080 by default
- Simple, secure, and ready for cloud deployment

---

## Usage

### 1. Build Your Spring Boot JAR

Build your application using Maven or Gradle:

```sh
./mvnw clean package
# or
./gradlew bootJar
```

Locate your JAR file (usually in `target/` or `build/libs/`).

### 2. Prepare the JAR for Docker

Copy your JAR file to this directory or specify the path to your JAR file when building the Docker image. You do not need to rename it to `app.jar`.

### 3. Run the Container

You can build the Docker image by specifying the JAR file path as a build argument:

```sh
docker build --build-arg JAR_FILE=target/your-app.jar -t <your-dockerhub-username>/springboot-java21-app:latest .
```

By default, the Dockerfile expects the JAR at `app.jar` in the build context. To use a different path, use the `JAR_FILE` build argument as shown above.

You can then run the container and pass environment variables using `-e` flags. For example:

```sh
docker run -e SPRING_PROFILES_ACTIVE=prod -e CUSTOM_ENV=foo -p 8080:8080 <your-dockerhub-username>/springboot-java21-app:latest
```

---

## Docker Compose Example

You can use Docker Compose to manage your Spring Boot container and other services (like databases) together. Here is a sample `docker-compose.yml`:

```yaml
version: '3.8'
services:
  app:
    image: <your-dockerhub-username>/springboot-java21-app:latest
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      CUSTOM_ENV: foo
    restart: unless-stopped
```

Here is an example showing how to build the image with a custom JAR file path:

```yaml
version: '3.8'
services:
  app:
    build:
      context: .
      args:
        JAR_FILE: target/your-app.jar  # Specify your JAR file path here
    image: <your-dockerhub-username>/springboot-java21-app:latest
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      CUSTOM_ENV: foo
    restart: unless-stopped
```

---

## Environment Variables

This image supports all standard Spring Boot environment variables. For example:
- `SPRING_PROFILES_ACTIVE`
- `SERVER_PORT`
- Any custom variables used in your application

---

## Example

```sh
docker run -e SPRING_PROFILES_ACTIVE=prod -e SERVER_PORT=9090 -p 9090:9090 <your-dockerhub-username>/springboot-java21-app:latest
```

---

## Advanced Usage

### Build Arguments
- `JAR_FILE`: Path to your built JAR file (default: `app.jar`)
- `APP_JAR_NAME`: Name for the JAR inside the image (default: `app.jar`)
- `APP_USER_UID`: UID for the non-root user (default: `10001`)
- `APP_USER_GID`: GID for the non-root user (default: `10001`)

Example:
```sh
docker build \
  --build-arg JAR_FILE=target/your-app.jar \
  --build-arg APP_JAR_NAME=myapp.jar \
  --build-arg APP_USER_UID=20000 \
  --build-arg APP_USER_GID=20000 \
  -t <your-dockerhub-username>/springboot-java21-app:latest .
```

### Passing JVM Options and Application Arguments

You can pass JVM options using the `JVM_OPTS` environment variable, and application arguments after the image name:

```sh
docker run -e JVM_OPTS="-Xms256m -Xmx512m" \
  -e SPRING_PROFILES_ACTIVE=prod \
  -p 8080:8080 \
  <your-dockerhub-username>/springboot-java21-app:latest \
  --spring.config.location=/app/config/
```

### OCI Image Metadata

This image includes an OCI label for source repository metadata. Update the `LABEL` in the Dockerfile to point to your repository.

### Multi-Architecture Build Example

You can build and push images for multiple architectures (e.g., amd64 and arm64) using Docker Buildx:

```sh
docker buildx create --use

docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg JAR_FILE=target/your-app.jar \
  -t <your-dockerhub-username>/springboot-java21-app:latest \
  --push .
```

---

## License

This project is provided as-is, without warranty. You are free to use and modify it for your own projects.

---

## Contributing

Feel free to open issues or submit pull requests to improve this image or its documentation.
# springboot-docker
