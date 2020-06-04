# FROM alpine:3.11 AS downloader

# RUN apk add -U --no-cache curl

# WORKDIR /etc
# # Configurable arguments defined at build time. User can override them by docker build --build-arg ARG_NAME=ARG_VALUE
# # Default OS type = linux
# ARG OS=linux
# # Default architecture = 64
# ARG ARCH=amd64
# # Download and unpack latest release from official github release
# RUN VERSION=$(curl -s https://github.com/trojan-gfw/trojan/releases/latest |grep -oE '\d\.\d+\.\d+') \
#     FILE=trojan-${VERSION}-${OS}-${ARCH}.tar.xz \
#     && echo "Got latest version = ${VERSION}, file = ${FILE}" \
#     && curl -L https://github.com/trojan-gfw/trojan/releases/download/v${VERSION}/$FILE | tar xvJ

# # Use distroless as minimal base image to package the executable binary
# # Refer to https://github.com/GoogleContainerTools/distroless for more details
# # Note: Use gcr.mirrors.ustc.edu.cn as repo-mirror if gcr.io is blocked by China GFW.
# FROM gcr.io/distroless/base:latest
# LABEL maintainer "Yanzhe Lee <lee.yanzhe@yanzhe.org>"
# WORKDIR /etc/trojan
# COPY --from=downloader /etc/trojan .
# ENV PATH /etc/trojan:$PATH
# CMD ["trojan", "-config=/etc/trojan/config.json"]
