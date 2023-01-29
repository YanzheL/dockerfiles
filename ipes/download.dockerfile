FROM alpine:3.17 AS downloader

RUN apk add -U --no-cache curl

WORKDIR /kuaicdn/app

ARG OS=linux

ARG ARCH=amd64

ARG EXTENSION=tar.gz

RUN curl -L https://ipes-tus.iqiyi.com/update/ipes-${OS}-${ARCH}-llc-latest.${EXTENSION} | tar xvz

# FROM gcr.io/distroless/base:latest
FROM alpine:3.17

WORKDIR /kuaicdn/app

COPY --from=downloader /kuaicdn/app .

ENV PATH /kuaicdn/app/ipes/bin:$PATH

CMD ["ipes", "start", "-f"]
