# Bugs Tracker Project

Welcome to the Bugs Tracker project! This application is a full-stack Java web service for tracking software bugs, built with Spring Boot, JSP, and MySQL. This guide will help you get started as a developer on this project.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Running with Docker Compose](#running-with-docker-compose)
  - [Manual Build & Run](#manual-build--run)
- [Project Structure](#project-structure)
- [Server Design](#server-design)
- [Client Design](#client-design)
- [Testing](#testing)
- [Localization](#localization)
- [Troubleshooting](#troubleshooting)
- [Known Issues & Limitations](#known-issues--limitations)

---

## Project Overview

This service allows users to create, view, filter, and manage bug reports. It features a RESTful backend, a JSP-based frontend, and uses MySQL for persistence. The UI supports filtering and adding bugs, and is localized using message bundles.

---

## Tech Stack

- **Backend:** Spring Boot, Spring MVC, Spring Data JPA, Liquibase, MapStruct
- **Frontend:** JSP, Bootstrap, jQuery
- **Database:** MySQL
- **Build:** Maven
- **Containerization:** Docker, Docker Compose

---

## Getting Started

### Prerequisites

- Java 21 (Temurin recommended)
- Maven 3.8+
- Docker & Docker Compose (for containerized setup)
- MySQL client (optional, for DB inspection)

### Running with Docker Compose

The easiest way to run the service and its dependencies is with Docker Compose.

1. **Copy and update environment variables:**
   - Rename `.env.sample` to `.env` in the project root.
   - Edit `.env` and update the database credentials and settings as needed for your environment.

2. **Build and start all services:**
   ```sh
   docker compose up --build
   ```
   This will:
   - Build the application Docker image.
   - Start a MySQL container.
   - Start the Bugs Tracker service, connected to the MySQL DB.

3. **Access the application:**
   - Open [http://localhost:8080](http://localhost:8080) in your browser.

4. **Stopping services:**
   ```sh
   docker compose down
   ```

### Manual Build & Run

If you want to run the app locally (not in Docker):

1. **Configure MySQL:**
   - Start a local MySQL server.
   - Create a database (e.g., `bugsdb`) and user matching the credentials in `application.properties` or your environment.

2. **Build the project:**
   ```sh
   mvn clean package
   ```

3. **Run the application:**
   ```sh
   mvn spring-boot:run
   ```
   or run the generated WAR in Tomcat 10+.

---

## Project Structure

```
src/
  main/
    java/               # Java source code
      com/bet99/bugs/
        controllers/    # REST and web controllers
        entities/       # JPA entities
        mappers/        # MapStruct mappers
        models/         # DTOs and enums
        repositories/   # Spring Data JPA repositories
        services/       # Service layer
        configurations/ # Spring configs, exception handlers
    resources/
      static/           # Static assets (js, css, images)
      templates/        # (if any, for Thymeleaf)
      messages.properties # Localization
      application.properties # Spring Boot config
    webapp/
      WEB-INF/views/    # JSP files
  test/                 # Unit tests
  integration-test/     # Integration tests
Dockerfile
docker-compose.yml
README.md
```

---

## Server Design

- **Spring Boot** is the entry point (`@SpringBootApplication`).
- **Controllers** handle REST (`/api/bugs`) and web requests.
- **Service Layer** contains business logic.
- **Repositories** use Spring Data JPA for DB access.
- **Liquibase** manages DB schema migrations.
- **MapStruct** handles mapping between entities and DTOs.
- **GlobalExceptionHandler** provides consistent error responses.

---

## Client Design

- **JSP** is used for server-side rendering of the UI.
- **Bootstrap** provides styling and responsive layout.
- **jQuery** is used for AJAX calls and DOM manipulation.
- **JavaScript** is organized in `src/main/resources/static/js/bugs.js`.
- **Localization**: All user-facing text is externalized in `messages.properties` and referenced via `<spring:message .../>` in JSP.

---

## Testing

- **Unit tests** are in `src/test/java`, named `*Test.java`, run by Surefire.
- **Integration tests** are in `src/integration-test/java`, named `*IntTest.java`, run by Failsafe.
- Use `mvn test` for unit tests, `mvn verify` for both unit and integration tests.

---

## Localization

- All UI text is in `messages.properties` (`src/main/resources/messages.properties`).
- Add new keys as needed for new UI elements.
- Use `<spring:message code="your.key"/>` in JSP to reference.

---

## Troubleshooting

- **404 for static files:**  
  Make sure JS/CSS/images are in `src/main/resources/static` and referenced as `/js/yourfile.js` (not `/static/js/yourfile.js`).
- **Database connection issues:**  
  Check your DB credentials and that the MySQL container/service is running.
- **JSP changes not reflected:**  
  If running in Docker, rebuild the image after JSP changes.

---

## Known Issues & Limitations

1. **Anonymous Access Only:**  
   The application does not implement any user authentication or authorization. All features are accessible to anyone who can reach the service.

2. **Database Setup Not Production Grade:**  
   The default MySQL setup (including credentials and configuration) is intended for development and testing only. For production, you should review and harden the database configuration, use secure credentials, and consider backups, monitoring, and scaling.

---

## Need Help?

- Check the comments in the code for guidance.
- Ask your team lead or a senior developer if you get stuck.
- Refer to this README for common setup and design questions.

Welcome aboard, and happy coding!