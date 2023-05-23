FROM amazoncorretto:17-alpine3.16

EXPOSE 8080

RUN mkdir /app

RUN apt-get update && apt-get upgrade

COPY ./target/camunda-7-plain-0.1.jar /app/spring-boot-application.jar

CMD ["java","-jar","/app/spring-boot-application.jar"]
