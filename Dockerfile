FROM eclipse-temurin:25-jdk AS build
WORKDIR /app
COPY . /app
RUN chmod +x mvnw
RUN ./mvnw package -DskipTests
RUN mv -f target/*.jar app.jar

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/app.jar ./

# Render asigna PORT automáticamente
ENV PORT=8080
EXPOSE ${PORT}

RUN useradd runtime
USER runtime

ENTRYPOINT ["java", "-Dserver.port=${PORT}", "-jar", "app.jar"]