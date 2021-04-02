FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04 as builder

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive

# Base dependencies
RUN apt -y update && \
    apt --no-install-recommends -y install \
        cmake \
        clang \
        llvm \
        lld \
        clang-tools \
        curl \
        git \
        git-lfs \
        python3-dev \
        python3-pip \
        default-jdk \
        ant && \
    pip3 install scipy

ENV ANT_HOME /usr/share/ant
ENV JAVA_HOME /usr/lib/jvm/default-java

# Use llvm toolchain instead of the default gcc
ENV CC=clang \
    CXX=clang++ \
    LD=ld.lld \
    AS=llvm-as \
    AR=llvm-ar \
    NM=llvm-nm \
    STRIP=llvm-strip \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    OBJSIZE=llvm-size \
    READELF=llvm-readelf

FROM builder as opencv_builder

# Optional dependencies
RUN apt --no-install-recommends -y install \
        libceres-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libavresample-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev

ARG OPENCV_VERSION=4.5.1
ENV OPENCV_VERSION=${OPENCV_VERSION}

WORKDIR /usr/src

RUN curl -vL https://github.com/opencv/opencv/archive/refs/tags/${OPENCV_VERSION}.tar.gz | tar xvz && \
    curl -vL https://github.com/opencv/opencv_contrib/archive/refs/tags/${OPENCV_VERSION}.tar.gz | tar xvz

# Optional OpenVINO for GAPI
# COPY --from=openvino/ubuntu20_dev:2021.3_src /opt/intel/ /builder-destdir/opt/intel/
# RUN ln -s /builder-destdir/opt/intel /opt/intel

WORKDIR /usr/src/opencv-${OPENCV_VERSION}/build

ARG CUDA_ARCH_BIN="6.1,6.2,7.0,7.2,7.5,8.0,8.6"
ENV CUDA_ARCH_BIN=${CUDA_ARCH_BIN}

ARG BUILD_SHARED_LIBS=ON
ARG BUILD_opencv_world=OFF

# Configure
RUN \
    # . /opt/intel/openvino/bin/setupvars.sh && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DPYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3 \
        -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
        -DOPENCV_DNN_CUDA=ON \
        -DOPENCV_ENABLE_NONFREE=ON \
        -DOPENCV_GENERATE_PKGCONFIG=ON \
        -DENABLE_THIN_LTO=ON \
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS} \
        -DBUILD_opencv_world=${BUILD_opencv_world} \
        -DBUILD_opencv_cvv=OFF \
        -DBUILD_opencv_gapi=OFF \
        -DBUILD_opencv_python2=OFF \
        -DBUILD_opencv_python3=ON \
        -DBUILD_opencv_cudalegacy=OFF \
        -DBUILD_DOCS=ON \
        -DBUILD_JPEG=ON \
        -DBUILD_PROTOBUF=ON \
        -DBUILD_TBB=ON \
        -DWITH_TBB=ON \
        -DWITH_CUDA=ON \
        -DWITH_OPENGL=ON \
        -DWITH_QT=OFF \
        -DWITH_VULKAN=ON \
        # -DWITH_INF_ENGINE=ON \
        # -DINF_ENGINE_RELEASE=2021030000 \
        -DCUDA_ARCH_BIN="${CUDA_ARCH_BIN}" \
        -DPYTHON3_INCLUDE_DIR=/usr/include/python3.8 \
        -DPYTHON3_PACKAGES_PATH=/usr/lib/python3.8/site-packages \
        -DCUDA_NVCC_FLAGS="-allow-unsupported-compiler" \
        -DCMAKE_INSTALL_PREFIX=/opt/opencv \
        -L \
        .. | tee BuildConfig.txt

# Build
RUN \
    # . /opt/intel/openvino/bin/setupvars.sh && \
    make -j"${jobs:-$(nproc)}"

# Install
RUN \
    # . /opt/intel/openvino/bin/setupvars.sh && \
    make DESTDIR=/builder-destdir install/strip && \
    cp BuildConfig.txt /builder-destdir/opt/opencv/ && \
    cp -r /builder-destdir/ /



FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04 as runtime

ENV DEBIAN_FRONTEND noninteractive

RUN apt -y update && \
    apt --no-install-recommends -y install \
        libceres1 \
        libavcodec58 \
        libavformat58 \
        libavutil56 \
        libswscale5 \
        libavresample4 \
        libgstreamer1.0-0 \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer-plugins-good1.0-0

COPY --from=opencv_builder /builder-destdir/ /