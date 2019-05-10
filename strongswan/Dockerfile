FROM alpine:edge

LABEL maintainer="Yanzhe Lee"

ENV STRONGSWAN_VERSION 5.7.2

ENV CC clang

ENV CXX clang++

RUN apk add build-base \
            clang-dev \
            curl-dev \
            openssl-dev \
            gmp-dev \
            curl \
            ip6tables \
            ca-certificates \
            iproute2 \
            linux-headers \
    && cd /tmp \
    && curl -L -o strongswan.gz https://download.strongswan.org/strongswan-${STRONGSWAN_VERSION}.tar.gz \
    && tar -zvxf strongswan.gz \
    && cd strongswan-${STRONGSWAN_VERSION} \
    && ./configure \
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
        --enable-swanctl \
        --enable-tpm \
        --enable-unity \
        --enable-vici \
    && make -j$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l) \
    && make install \
    && cd / \
    && rm -rf /tmp/* \
    && apk del build-base curl-dev openssl-dev clang-dev \
    && rm -rf /var/cache/apk/* \
    && ln -s /etc/ssl/certs/*.pem /usr/local/etc/ipsec.d/cacerts/

EXPOSE 500/udp \
       4500/udp

WORKDIR /usr/local/etc

CMD ["ipsec", "start", "--nofork"]