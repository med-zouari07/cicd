FROM openjdk:11
ADD target/ExamThourayaS2-0.0.1.jar app.jar
EXPOSE 8089
ENTRYPOINT ["java", "-jar", "app.jar"]
