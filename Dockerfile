FROM bitnami/minideb:stretch
LABEL maintainer="rainer.stuetz@ait.ac.at"

RUN useradd -r -u 10000 dockeruser && \
    mkdir -p /opt/graphsense/data && \
    chown dockeruser /opt/graphsense && \
    # packages
    apt-get update && \
    apt-get install --no-install-recommends -y \
        automake \
        autotools-dev \
        binutils \
        bsdmainutils \
        build-essential \
        ca-certificates \
        git \
        libboost-chrono1.62-dev \
        libboost-chrono1.62.0 \
        libboost-filesystem1.62-dev \
        libboost-filesystem1.62.0 \
        libboost-program-options1.62-dev \
        libboost-program-options1.62.0 \
        libboost-system1.62-dev \
        libboost-system1.62.0 \
        libboost-test1.62-dev \
        libboost-test1.62.0 \
        libboost-thread1.62-dev \
        libboost-thread1.62.0 \
        libevent-dev \
        libminiupnpc-dev \
        libprotobuf-dev \
        libssl-dev \
        libtool \
        pkg-config \
        wget

ADD docker/litecoin.conf /opt/graphsense/litecoin.conf
ADD docker/Makefile /tmp/Makefile
RUN cd /tmp && \
    make install && \
    strip /usr/local/bin/*litecoin* && \
    cd / && \
    rm -rf /tmp/src && \
    apt-get autoremove --purge -y \
        autoconf \
        automake \
        autotools-dev \
        binutils \
        build-essential \
        gcc \
        git \
        libboost-atomic1.62-dev \
        libboost-chrono1.62-dev \
        libboost-date-time1.62-dev \
        libboost-filesystem1.62-dev \
        libboost-program-options1.62-dev \
        libboost-serialization1.62-dev \
        libboost-system1.62-dev \
        libboost-test1.62-dev \
        libboost-thread1.62-dev \
        libssl-dev \
        libtool \
        perl \
        protobuf-compiler && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER dockeruser
EXPOSE 8532

CMD litecoind -conf=/opt/graphsense/litecoin.conf -datadir=/opt/graphsense/data -daemon -rest && bash
