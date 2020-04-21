FROM registry.access.redhat.com/ubi8/ubi-minimal

# Note: If you are behind a web proxy, set the build variables for the build:
#       E.g.:  docker build --build-arg "https_proxy=..." --build-arg "http_proxy=..." --build-arg "no_proxy=..." ...

ARG GRAALVM_VERSION=20.0.1
ARG JAVA_VERSION=java11
ARG TARGETPLATFORM=linux-amd64

ENV LANG=en_US.UTF-8 \
    JAVA_HOME=/opt/graalvm-ee-$JAVA_VERSION-$GRAALVM_VERSION

COPY graalvm-ee-java11-${GRAALVM_VERSION}/bin /opt/
ADD gu-wrapper.sh /usr/local/bin/gu

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

ENV GRAALVM_VERSION=${GRAALVM_VERSION}
ENV JAVA_VERSION=${JAVA_VERSION}
ENV TARGETPLATFORM=${TARGETPLATFORM}

CMD ["java", "-version"]
