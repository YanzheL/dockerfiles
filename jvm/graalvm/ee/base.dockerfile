FROM registry.access.redhat.com/ubi8/ubi

ARG GRAALVM_VERSION
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

RUN set -eux \
    # Set alternative links
    && mkdir -p "/usr/java" \
    && ln -sfT "$JAVA_HOME" /usr/java/default \
    && ln -sfT "$JAVA_HOME" /usr/java/latest \
    && for bin in "$JAVA_HOME/bin/"*; do \
        base="$(basename "$bin")"; \
        [ ! -e "/usr/bin/$base" ]; \
        alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
       done \
    && chmod +x /usr/local/bin/gu


CMD ["java", "-version"]
