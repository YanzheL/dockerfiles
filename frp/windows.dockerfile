FROM mcr.microsoft.com/windows/nanoserver:ltsc2022
LABEL maintainer "Yanzhe Lee <lee.yanzhe@yanzhe.org>"
WORKDIR /etc/frp
COPY frpc.exe /etc/frp/
ENV PATH /etc/frp:$PATH
CMD ["frpc", "-c", "frpc.ini"]
