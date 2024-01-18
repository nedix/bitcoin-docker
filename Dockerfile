ARG ALPINE_VERSION=3.19
ARG BITCOIN_VERSION=26.0

FROM btcpayserver/bitcoin:${BITCOIN_VERSION} as build

RUN apt update \
    && apt install -y \
        curl \
        uuid-runtime

COPY --chown=nobody rootfs /

RUN mkdir -p \
        /var/bitcoin \
    && chown nobody /var/bitcoin

#USER nobody

EXPOSE 8332/tcp

VOLUME /var/bitcoin

ENTRYPOINT ["/entrypoint.sh"]
