FROM gradle:5.6-jdk8 AS jdk_builder
USER root
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        git \
        ca-certificates
ARG VERSION=2.0.79
RUN git clone -b ${VERSION} https://github.com/linkedin/cruise-control.git
WORKDIR /home/gradle/cruise-control
ARG GRADLE_EXTRA_OPTS
RUN gradle $GRADLE_EXTRA_OPTS jar copyDependantLibs

RUN mv -v \
        cruise-control/build/libs/cruise-control-${VERSION}.jar \
        cruise-control/build/libs/cruise-control.jar \
    && mv -v \
        cruise-control/build/dependant-libs/cruise-control-metrics-reporter-${VERSION}.jar \
        cruise-control/build/dependant-libs/cruise-control-metrics-reporter.jar

FROM node:13 AS node_builder
RUN mkdir /src \
    && cd /src \
    && git clone https://github.com/linkedin/cruise-control-ui.git
WORKDIR /src/cruise-control-ui
#RUN git checkout dfc257cecb59f1be703ddb0ff3ce8522c9b3685f
RUN npm install
RUN npm run build

# The container is made to work with github.com/Yolean/kubernetes-kafka, so we try to use a common base
FROM openjdk:8
ARG SOURCE_REF
ARG SOURCE_TYPE
ARG DOCKERFILE_PATH
ARG VERSION

RUN mkdir -p /opt/cruise-control /opt/cruise-control/cruise-control-ui
COPY --from=jdk_builder /home/gradle/cruise-control/cruise-control/build/libs/cruise-control.jar /opt/cruise-control/cruise-control/build/libs/cruise-control.jar
COPY --from=jdk_builder /home/gradle/cruise-control/config /opt/cruise-control/config
COPY --from=jdk_builder /home/gradle/cruise-control/kafka-cruise-control-start.sh /opt/cruise-control/
COPY --from=jdk_builder /home/gradle/cruise-control/cruise-control/build/dependant-libs /opt/cruise-control/cruise-control/build/dependant-libs
COPY opt/cruise-control /opt/cruise-control/
COPY --from=node_builder /src/cruise-control-ui/dist /opt/cruise-control/cruise-control-ui/dist
RUN echo "local,localhost,/kafkacruisecontrol" > /opt/cruise-control/cruise-control-ui/dist/static/config.csv

EXPOSE 8090
CMD [ "/opt/cruise-control/start.sh" ]
