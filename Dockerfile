# Utiliser OpenJDK 17
FROM eclipse-temurin:17-jdk-alpine

# Répertoire de travail dans le container
WORKDIR /app

# Copier le jar compilé
COPY target/task-api-0.3.0.jar app.jar

# Exposer le port de l'application
EXPOSE 8080

# Lancer l'application
ENTRYPOINT ["java","-jar","app.jar"]