FROM gradle:8.5.0-jdk17 AS builder
WORKDIR /workdir
COPY . .

# --- Runtime container ---
RUN ./gradlew shadowJar --no-daemon

FROM eclipse-temurin:23-jdk-noble
WORKDIR /workdir
COPY --from=builder /workdir/app/build/libs/app.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
