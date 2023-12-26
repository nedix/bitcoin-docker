ARG BITCOIN_VERSION=26.0


FROM --platform=$BUILDPLATFORM btcpayserver/bitcoin:${BITCOIN_VERSION} as build

RUN apt update \
    && apt install -y \
        curl \
        uuid-runtime

COPY --chown=nobody rootfs /

RUN mkdir -p \
        /var/bitcoin \
    && chown nobody /var/bitcoin

USER nobody

VOLUME /var/bitcoin


FROM build as full-mode

RUN chmod -x \
        /entrypoint-light-mode.sh \
    && chmod +x \
        /entrypoint-full-mode.sh

ENTRYPOINT ["/entrypoint-full-mode.sh"]


FROM build as light-mode

RUN chmod -x \
        /entrypoint-full-mode.sh \
    && chmod +x \
        /entrypoint-light-mode.sh

ENTRYPOINT ["/entrypoint-light-mode.sh"]

EXPOSE 8332/tcp
