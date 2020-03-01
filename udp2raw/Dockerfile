FROM alpine:3.11 AS builder

WORKDIR /tmp

RUN apk add -U \
    linux-headers \
    build-base \
    clang \
    git

ARG TARGET=amd64_hw_aes

RUN git clone https://github.com/wangyu-/udp2raw-tunnel \
    && cd udp2raw-tunnel \
    && sed -i 's/cc_local=.*/cc_local=clang++/g' makefile \
    && OPT="-Wl,--strip-debug" make -j$(nproc) ${TARGET}


FROM gcr.io/distroless/base:latest

LABEL maintainer "Yanzhe Lee <lee.yanzhe@yanzhe.org>"

COPY --from=builder /tmp/udp2raw-tunnel/udp2raw_* /usr/bin/udp2raw

ENTRYPOINT [ "/usr/bin/udp2raw" ]