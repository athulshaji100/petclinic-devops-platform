FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

RUN adduser --disabled-password --gecos "" appuser

COPY target/*.jar app.jar

USER appuser

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "app.jar"]