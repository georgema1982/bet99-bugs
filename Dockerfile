# Use an OpenJDK base image
FROM eclipse-temurin:17-jdk as build

# Set working directory
WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY mvnw pom.xml ./
COPY .mvn .mvn

# Copy source code
COPY src ./src

# Build the application (WAR file)
RUN ./mvnw clean package -DskipTests

# Use a Tomcat base image for deployment
FROM tomcat:10.1-jdk17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file to Tomcat webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]