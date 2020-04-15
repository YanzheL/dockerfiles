FROM alpine:3.11 AS builder

RUN apk add --no-cache \
        build-base \
        clang-dev \
        curl-dev \
        curl \
        openssl-dev \
        gmp-dev \
        ca-certificates \
        linux-headers \
        lld \
        llvm-dev

ARG STRONGSWAN_VERSION=5.8.4

RUN cd /tmp && \
    curl -L https://download.strongswan.org/strongswan-${STRONGSWAN_VERSION}.tar.gz | tar zxf - 

WORKDIR /tmp/strongswan-${STRONGSWAN_VERSION}/build

ENV CC=clang
ENV CXX=clang-cpp
ENV LD=ld.lld
ENV AR=llvm-ar
ENV AS=llvm-as
ENV NM=llvm-nm
ENV STRIP=llvm-strip
ENV OBJCOPY=llvm-objcopy
ENV OBJDUMP=llvm-objdump
ENV OBJSIZE=llvm-size
ENV READELF=llvm-readelf
ENV LDFLAGS="-Wl,--strip-debug"
ENV CPPFLAGS="-flto"
# ENV CPPFLAGS="-flto -fsanitize=cfi -fvisibility=hidden"
ENV CFLAGS=$CPPFLAGS

RUN ../configure \
        --disable-stroke \
        --disable-scepclient \
        --disable-ikev1 \
        --enable-addrblock \
        --enable-aesni \
        --enable-attr \
        --enable-af-alg \
        --enable-bypass-lan \
        --enable-certexpire \
        --enable-chapoly \
        --enable-constraints \
        --enable-counters \
        --enable-curl \
        --enable-ctr \
        --enable-curve25519 \
        --enable-dhcp \
        --enable-eap-dynamic \
        --enable-eap-identity \
        --enable-eap-md5 \
        --enable-eap-mschapv2 \
        --enable-eap-peap \
        --enable-eap-radius \
        --enable-eap-tls \
        --enable-eap-tnc \
        --enable-eap-ttls \
        --enable-error-notify \
        --enable-ext-auth \
        --enable-farp \
        --enable-files \
        --enable-gcm \
        --enable-lookip \
        --enable-newhope \
        --enable-ntru \
        --enable-openssl \
        --enable-pkcs11 \
        --enable-radattr \
        --enable-sha3 \
        --enable-tpm

RUN make -j$(nproc) && \
    make DESTDIR=/usr/src/app install

FROM alpine:3.11

LABEL maintainer "Yanzhe Lee <lee.yanzhe@yanzhe.org>"

RUN apk add --no-cache \
        curl \
        openssl \
        gmp \
        ip6tables \
        ca-certificates \
        iproute2 \
        bash \
        ack

COPY --from=builder /usr/src/app /

WORKDIR /usr/local/etc

ENTRYPOINT [ "/usr/local/libexec/ipsec/charon" ]
