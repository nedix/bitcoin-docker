ARG ALPINE_VERSION=3.20
ARG BITCOIN_VERSION=27.1
ARG QUIX_SIGS_VERSION=5398474c82d8b6aec7b3956b1a6addac6c36010b

FROM alpine:${ALPINE_VERSION} AS bitcoin

ARG BITCOIN_VERSION
ARG QUIX_SIGS_VERSION

RUN apk add \
        autoconf \
        automake \
        boost-dev \
        build-base \
        chrpath \
        file \
        git \
        gnupg \
        libevent-dev \
        libressl \
        libtool \
        linux-headers \
        sqlite-dev \
        zeromq-dev

WORKDIR /tmp/guix.sigs/

RUN git init "$PWD" \
    && git remote add -f origin -t \* https://github.com/bitcoin-core/guix.sigs \
    && git checkout "$QUIX_SIGS_VERSION" \
    && gpg --import ./builder-keys/* \
    && rm -rf "$PWD"

WORKDIR /build/bitcoin/

RUN git init "$PWD" \
    && git remote add -f origin -t \* https://github.com/bitcoin/bitcoin.git \
    && git checkout "v${BITCOIN_VERSION}" \
    && git verify-tag "v${BITCOIN_VERSION}"

RUN ./autogen.sh \
    && ./configure \
        CXXFLAGS="-O2" \
        --prefix="/opt/bitcoin" \
        --disable-ccache \
        --disable-man \
        --disable-shared \
        --disable-tests \
        --enable-reduce-exports \
        --enable-static \
        --with-daemon \
        --with-sqlite=yes \
        --with-utils \
        --without-gui \
        --without-libs \
    && make -j$(( $(nproc) + 1 )) \
    && make install \
    && strip -v /opt/bitcoin/bin/bitcoin* \
    && sha256sum /opt/bitcoin/bin/bitcoin*

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
        libevent \
        libsodium \
        libstdc++ \
        libzmq \
        sqlite-libs

COPY --link --from=bitcoin /opt/bitcoin/bin/bitcoin*  /usr/local/bin/

COPY /rootfs/ /

ENTRYPOINT ["/entrypoint.sh"]

# REST
EXPOSE 8080

# RPC (mainnet, testnet, regnet)
EXPOSE 8332 18332 18443

# P2P (mainnet, testnet, regnet)
EXPOSE 8333 18333 18444

# ZMQ
EXPOSE 28332 28333
