FROM openjdk:13-alpine

LABEL maintainer="Yanzhe Lee"

WORKDIR /usr/src/app/

RUN apk add curl \
    && curl -L -o littleproxy.jar $(curl -s https://api.github.com/repos/adamfisk/LittleProxy/releases/latest | grep browser_download_url | cut -d '"' -f 4)

EXPOSE 8080

CMD ["java","-server","-XX:+HeapDumpOnOutOfMemoryError","-Xmx200m","-jar","littleproxy.jar"]