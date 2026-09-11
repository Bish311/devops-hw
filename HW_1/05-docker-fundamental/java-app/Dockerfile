FROM eclipse-temurin:17-alpine

WORKDIR /app

COPY Server.java ./
RUN javac Server.java

EXPOSE 8000

CMD ["java", "Server"]
