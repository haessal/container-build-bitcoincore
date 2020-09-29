FROM ubuntu:20.04

LABEL maintainer="haessal@mizutamauki.net"

ENV DEBIAN_FRONTEND=noninteractive

# upgrade packages and install common tools
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
        && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install tools to build
RUN apt-get update && apt-get install -y --no-install-recommends \
            build-essential \
            libtool \
            autotools-dev \
            automake \
            pkg-config \
            bsdmainutils \
            python3 \
        && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# build and install libdb4.8
ARG BDB_WORKDIR='/root/libdb'
ARG INSTALL_BDB4_FILE='install_db4.sh'
RUN set -x \
        && mkdir -p ${BDB_WORKDIR} && cd ${BDB_WORKDIR} \
        && curl --location --fail --connect-timeout 30 --retry 5 -O \
                https://raw.githubusercontent.com/bitcoin/bitcoin/v0.20.1/contrib/${INSTALL_BDB4_FILE} \
        && sed -i.old 's/make install/make libdb_cxx-4.8.a libdb-4.8.a \&\& make install_lib install_include/' ${INSTALL_BDB4_FILE} \
        && chmod 755 ${INSTALL_BDB4_FILE} && ./${INSTALL_BDB4_FILE} `pwd` --prefix="/usr/local" \
        && cd /root && rm -R ${BDB_WORKDIR}

# install required libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
            libevent-dev \
            libboost-system-dev \
            libboost-filesystem-dev \
            libboost-test-dev \
            libboost-thread-dev \
        && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install optional libraries except GUI-related
RUN apt-get update && apt-get install -y --no-install-recommends \
            libminiupnpc-dev \
            libzmq3-dev \
        && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
