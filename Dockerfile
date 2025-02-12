FROM ubuntu:24.04 as builder
LABEL org.opencontainers.image.title="ltc-client"
LABEL org.opencontainers.image.maintainer="contact@ikna.io"
LABEL org.opencontainers.image.url="https://www.ikna.io/"
LABEL org.opencontainers.image.description="Dockerized Litecoin client"
LABEL org.opencontainers.image.source="https://github.com/graphsense/ltc-client"

ENV TZ=UTC
ENV LIBDIR=/etc/ld.so.conf
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
        libdb++-dev \
        libevent-dev \
        libfmt-dev \
        libminiupnpc-dev \
        libprotobuf-dev \
        libssl-dev \
        libtool \
        pkg-config \
        wget && \
    cd /tmp && \
    make install && \
    strip /usr/local/bin/litecoin*

FROM ubuntu:24.04

COPY --from=builder /usr/local/bin/litecoin* /usr/local/bin/

ARG UID=10000

RUN useradd -r -u $UID dockeruser && \
    mkdir -p /opt/graphsense/data && \
    chown -R dockeruser /opt/graphsense && \
    # packages
    apt-get update && \
    apt-get install --no-install-recommends -y \
        libboost-all-dev \
        libfmt9 \
        libevent-core-2.1-7t64 \
        libevent-pthreads-2.1-7t64 \
        libminiupnpc17 \
        libssl-dev

USER dockeruser
CMD ["litecoind", "-conf=/opt/graphsense/client.conf", "-datadir=/opt/graphsense/data", "-rest"]
