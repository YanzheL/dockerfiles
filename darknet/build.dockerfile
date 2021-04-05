FROM leeyanzhe/opencv:dev as darknet_builder

RUN git clone --depth 1 https://github.com/AlexeyAB/darknet.git /usr/src/darknet

ENV LD_LIBRARY_PATH /usr/local/cuda/compat:${LD_LIBRARY_PATH}

WORKDIR /usr/src/darknet/temp

RUN sed -i 's/cmake_minimum_required(VERSION 3.18)/cmake_minimum_required(VERSION 3.16)/g' ../CMakeLists.txt

RUN \
    . /opt/opencv/bin/setup_vars_opencv4.sh && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/darknet \
        -DBUILD_AS_CPP=ON \
        -DINSTALL_BIN_DIR=/opt/darknet/bin \
        -DINSTALL_LIB_DIR=/opt/darknet/lib \
        ..

RUN \
    . /opt/opencv/bin/setup_vars_opencv4.sh && \
    make -j"${jobs:-$(nproc)}"

RUN \
    . /opt/opencv/bin/setup_vars_opencv4.sh && \
    make DESTDIR=/darknet_builder install && \
    make install

FROM leeyanzhe/opencv:runtime

ENV LD_LIBRARY_PATH /opt/darknet/lib:${LD_LIBRARY_PATH}

ENV PATH /opt/darknet/bin:${PATH}

COPY --from=darknet_builder /darknet_builder/ /

CMD [ "darknet", "--help" ]