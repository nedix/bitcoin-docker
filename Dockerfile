ARG BITCOIN_VERSION=26.0

FROM --platform=$BUILDPLATFORM btcpayserver/bitcoin:${BITCOIN_VERSION}

RUN apt update \
    && apt install -y \
        curl \
        uuid-runtime

ADD rootfs /

RUN mkdir -p /var/bitcoin \
    && chown nobody /var/bitcoin \
    && chmod +x /entrypoint.sh

USER nobody

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /var/bitcoin

EXPOSE 8332/tcp
