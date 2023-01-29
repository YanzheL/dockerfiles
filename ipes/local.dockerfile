# FROM gcr.io/distroless/base:latest
FROM alpine:3.17

WORKDIR /kuaicdn/app

ADD ./ipes-linux-amd64-llc-latest.tar.gz .

ENV PATH /kuaicdn/app/ipes/bin:$PATH

CMD ["ipes", "start", "-f"]