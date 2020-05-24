FROM scratch

ARG GRAALVM_VERSION=20.0.1
ARG JAVA_VERSION=java11
ARG TARGETPLATFORM=linux-amd64

ADD graalvm-ee-java11-${TARGETPLATFORM}-${GRAALVM_VERSION}.tar.gz /opt/
ADD gu-wrapper.sh /usr/local/bin/gu

ENV GRAALVM_VERSION=${GRAALVM_VERSION}
ENV JAVA_VERSION=${JAVA_VERSION}
ENV TARGETPLATFORM=${TARGETPLATFORM}
ENV LANG=en_US.UTF-8
ENV JAVA_HOME=/opt/graalvm-ee-${JAVA_VERSION}-${GRAALVM_VERSION}
ENV GRAALVM_HOME=${JAVA_HOME}
ENV PATH="${JAVA_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

VOLUME [ "/lib" ]
VOLUME [ "/lib64" ]

CMD ["java", "-version"]
