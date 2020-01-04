FROM alpine:edge AS builder

WORKDIR /app/v2ray

RUN apk add -U curl unzip \
    && VERSION=$(curl -s https://github.com/v2ray/v2ray-core/releases/latest |grep -oE '\d\.\d+\.\d+') \
    && echo "Got latest version = $VERSION" \
    && wget https://github.com/v2ray/v2ray-core/releases/download/v${VERSION}/v2ray-linux-64.zip \
    && unzip v2ray-linux-64.zip \
    && rm v2ray-linux-64.zip

FROM alpine:edge

COPY --from=builder /app/v2ray /app/v2ray

ENV PATH /app/v2ray:$PATH

CMD ["v2ray", "-config=/etc/v2ray/config.json"]