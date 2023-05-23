FROM amazoncorretto:17-alpine3.18

EXPOSE 8080

RUN mkdir /app

COPY ./target/camunda-7-plain-0.1.jar /app/spring-boot-application.jar

CMD ["java","-jar","/app/spring-boot-application.jar"]
