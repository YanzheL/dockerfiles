FROM registry.access.redhat.com/ubi8/ubi

ARG URL

ENV LANG=en_US.UTF-8

RUN set -eux \
    && cd /opt \
    && curl -L "$URL" | tar xvz \
    && cd * \
    && export JAVA_HOME="$(pwd)" \
    # Set alternative links
    && mkdir -p "/usr/java" \
    && ln -sfT "$JAVA_HOME" /usr/java/default \
    && ln -sfT "$JAVA_HOME" /usr/java/latest \
    && for bin in "$JAVA_HOME/bin/"*; do \
        base="$(basename "$bin")"; \
        [ ! -e "/usr/bin/$base" ]; \
        alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
       done

CMD [ "java", "-version"]