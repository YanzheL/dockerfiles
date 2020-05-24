FROM leeyanzhe/graalvm:ee-java11

ARG GRAALVM_VERSION
ARG JAVA_VERSION=java11
ARG TARGETPLATFORM=linux-amd64

ADD native-image-installable-svm-svmee-${JAVA_VERSION}-${TARGETPLATFORM}-${GRAALVM_VERSION}.jar /opt/
RUN gu -L install /opt/native-image-installable-svm-svmee-${JAVA_VERSION}-${TARGETPLATFORM}-${GRAALVM_VERSION}.jar \
    && rm /opt/native-image-installable-svm-svmee-${JAVA_VERSION}-${TARGETPLATFORM}-${GRAALVM_VERSION}.jar

CMD ["java", "-version"]
