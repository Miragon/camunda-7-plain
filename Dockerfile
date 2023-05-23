FROM alpine:3.18

# --- START AMAZON CORRETTO https://github.com/corretto/corretto-docker/blob/main/17/slim/alpine/Dockerfile ---

ARG version=17.0.7.7.1

RUN wget -O /THIRD-PARTY-LICENSES-20200824.tar.gz https://corretto.aws/downloads/resources/licenses/alpine/THIRD-PARTY-LICENSES-20200824.tar.gz && \
    echo "82f3e50e71b2aee21321b2b33de372feed5befad6ef2196ddec92311bc09becb  /THIRD-PARTY-LICENSES-20200824.tar.gz" | sha256sum -c - && \
    tar x -ovzf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    rm -rf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    wget -O /etc/apk/keys/amazoncorretto.rsa.pub https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    SHA_SUM="6cfdf08be09f32ca298e2d5bd4a359ee2b275765c09b56d514624bf831eafb91" && \
    echo "${SHA_SUM}  /etc/apk/keys/amazoncorretto.rsa.pub" | sha256sum -c - && \
    echo "https://apk.corretto.aws" >> /etc/apk/repositories && \
    apk add --no-cache amazon-corretto-17=$version-r0 binutils && \
    /usr/lib/jvm/default-jvm/bin/jlink --add-modules "$(java --list-modules | sed -e 's/@[0-9].*$/,/' | tr -d \\n)" --no-man-pages --no-header-files --strip-debug --output /opt/corretto-slim && \
    apk del binutils amazon-corretto-17 && \
    mkdir -p /usr/lib/jvm/ && \
    mv /opt/corretto-slim /usr/lib/jvm/java-17-amazon-corretto && \
    ln -sfn /usr/lib/jvm/java-17-amazon-corretto /usr/lib/jvm/default-jvm

ENV LANG C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$PATH:/usr/lib/jvm/default-jvm/bin

# --- END AMAZON CORRETTO ---

EXPOSE 8080

RUN mkdir /app

COPY ./target/camunda-7-plain-0.1.jar /app/spring-boot-application.jar

CMD ["java","-jar","/app/spring-boot-application.jar"]
