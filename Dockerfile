# ====== Build ======
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw && ./mvnw -q -DskipTests dependency:go-offline
COPY src ./src
RUN ./mvnw -q -DskipTests clean package

# ====== Runtime ======
FROM eclipse-temurin:17-jre
WORKDIR /app
RUN useradd -r -u 1001 appuser && chown -R appuser /app
USER appuser
COPY --from=build /app/target/disciplinas-svc-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8082
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0"
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar app.jar"]
