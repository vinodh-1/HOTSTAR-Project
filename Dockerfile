 # ---------- Stage 1 : Build ----------
FROM maven:3.9.9-eclipse-temurin-17-alpine AS build

WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build WAR file
RUN mvn clean package -DskipTests


# ---------- Stage 2 : Runtime ----------
FROM tomcat:9.0-alpine

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
