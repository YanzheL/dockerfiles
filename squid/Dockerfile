FROM ubuntu AS production_env

RUN apt -y update \
    && apt -y install libxml2-dev \
                      libecap3-dev \
                      libldap2-dev \
                      libpam0g-dev \
                      libsasl2-dev \
                      krb5-multidev \
                      libssl-dev

FROM production_env AS builder

RUN apt -y update \
    && apt -y install build-essential \
                      git \
                      curl \
                      wget
RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" >> /etc/apt/sources.list.d/llvm.list \
    && echo "deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" >> /etc/apt/sources.list.d/llvm.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 15CF4D18AF4F7421 \
    && apt -y update \
    && apt -y install clang-9

ENV CC clang-9
ENV CXX clang++-9
ENV CXXFLAGS=-Wno-error=defaulted-function-deleted

WORKDIR /usr/src

ENV SQUID_VERSION 4.7

RUN wget http://www.squid-cache.org/Versions/v4/squid-$SQUID_VERSION.tar.xz \
    && tar -xf *.xz

WORKDIR /usr/src/squid-$SQUID_VERSION

RUN ./configure \
    --prefix=/usr \
    --sysconfdir=/etc/squid \
    --disable-maintainer-mode \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --disable-arch-native \
    --disable-translation \
    --enable-inline \
    --enable-async-io=8 \
    --enable-storeio=ufs,aufs,diskd,rock \
    --enable-removal-policies=lru,heap \
    --enable-delay-pools \
    --enable-cache-digests \
    --enable-icap-client \
    --enable-follow-x-forwarded-for \
    --enable-auth-basic=DB,fake,getpwnam,LDAP,NCSA,NIS,PAM,POP3,RADIUS,SASL,SMB \
    --enable-auth-digest=file,LDAP \
    --enable-auth-negotiate=kerberos,wrapper \
    --enable-auth-ntlm=fake,SMB_LM \
    --enable-external-acl-helpers=file_userip,kerberos_ldap_group,LDAP_group,unix_group,wbinfo_group \
    --enable-security-cert-validators=fake \
    --enable-storeid-rewrite-helpers=file \
    --enable-url-rewrite-helpers=fake \
    --enable-eui \
    --enable-esi \
    --enable-icmp \
    --enable-zph-qos \
    --enable-linux-netfilter \
    --enable-http-violation \
    --with-swapdir=/var/spool/squid \
    --with-logdir=/var/log/squid \
    --with-pidfile=/var/run/squid.pid \
    --with-filedescriptors=65536 \
    --with-large-files \
    --with-default-user=proxy \
    --with-openssl

RUN make -j$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l) \
    && mkdir /usr/src/build \
    && make DESTDIR=/usr/src/build install
    # && make install

FROM production_env

ENV SQUID_CACHE_DIR=/var/spool/squid
ENV SQUID_LOG_DIR=/var/log/squid
ENV SQUID_USER=proxy

COPY --from=builder /usr/src/build /

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128

ENTRYPOINT ["/sbin/entrypoint.sh"]