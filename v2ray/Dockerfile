FROM alpine:3.11 AS builder

WORKDIR /etc/v2ray

RUN apk add -U --no-cache curl

RUN VERSION=$(curl -s https://github.com/v2ray/v2ray-core/releases/latest |grep -oE '\d\.\d+\.\d+') \
    && echo "Got latest version = $VERSION" \
    && curl -Lo v2ray-linux-64.zip https://github.com/v2ray/v2ray-core/releases/download/v${VERSION}/v2ray-linux-64.zip \
    && unzip v2ray-linux-64.zip \
    && rm v2ray-linux-64.zip

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:latest
WORKDIR /
COPY --from=builder /etc/v2ray /etc/v2ray
VOLUME [ "/etc/v2ray/config.json" ]
ENTRYPOINT ["/etc/v2ray/v2ray"]
CMD ["-config=/etc/v2ray/config.json"]
