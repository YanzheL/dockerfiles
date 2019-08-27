FROM alpine:edge AS builder

LABEL maintainer="Yanzhe Lee"

ENV STRONGSWAN_VERSION 5.8.0

RUN apk add build-base \
            clang-dev \
            curl-dev \
            curl \
            openssl-dev \
            gmp-dev \
            ca-certificates \
            linux-headers \
            lld \
            llvm-dev

RUN cd /tmp \
    && curl -L https://download.strongswan.org/strongswan-${STRONGSWAN_VERSION}.tar.gz | tar zxf - 

WORKDIR /tmp/strongswan-${STRONGSWAN_VERSION}/build

ENV CC clang
ENV CXX clang++
ENV LD ld.lld
ENV AR llvm-ar
ENV AS llvm-as
ENV CPPFLAGS "-flto"
ENV CFLAGS "-flto"

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

RUN make -j$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l) \
    && make DESTDIR=/usr/src/app install

FROM alpine:edge

RUN apk add curl \
            openssl \
            gmp \
            ip6tables \
            ca-certificates \
            iproute2

COPY --from=builder /usr/src/app /

WORKDIR /usr/local/etc

ENTRYPOINT [ "/usr/local/libexec/ipsec/charon" ]
