FROM ubuntu:20.04 as builder
LABEL maintainer="contact@graphsense.info"

ARG UID=10000

ENV TZ=UTC
ADD docker/Makefile /tmp/Makefile
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        automake \
        autotools-dev \
        binutils \
        bsdmainutils \
        build-essential \
        ca-certificates \
        git \
        libboost-all-dev \
        libevent-dev \
        libminiupnpc-dev \
        libprotobuf-dev \
        libssl-dev \
        libtool \
        pkg-config \
        wget && \
    cd /tmp && \
    make install && \
    strip /usr/local/bin/litecoin*

FROM ubuntu:20.04

COPY --from=builder /usr/local/bin/litecoin* /usr/local/bin/

RUN useradd -r -u $UID dockeruser && \
    mkdir -p /opt/graphsense/data && \
    chown -R dockeruser /opt/graphsense && \
    # packages
    apt-get update && \
    apt-get install --no-install-recommends -y \
        libboost-chrono1.71.0 \
        libboost-filesystem1.71.0 \
        libboost-program-options1.71.0 \
        libboost-system1.71.0 \
        libboost-thread1.71.0 \
        libevent-2.1-7 \
        libevent-pthreads-2.1-7 \
        libminiupnpc17 \
        libssl1.1

ADD docker/litecoin.conf /opt/graphsense/litecoin.conf

USER dockeruser
CMD ["litecoind", "-conf=/opt/graphsense/litecoin.conf", "-datadir=/opt/graphsense/data", "-rest"]
