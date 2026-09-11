# ----------------------------------------------------
# Stage 1: Compile Java Source
# ----------------------------------------------------
FROM eclipse-temurin:17-jdk-alpine AS compiler

WORKDIR /build
COPY Server.java ./
RUN javac Server.java

# ----------------------------------------------------
# Stage 2: Minimal JRE Runtime
# ----------------------------------------------------
FROM eclipse-temurin:17-jre-alpine AS runtime

WORKDIR /app
COPY --from=compiler /build/Server*.class ./

EXPOSE 8000
CMD ["java", "Server"]
