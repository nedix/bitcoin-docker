ARG ALPINE_VERSION=3.19
ARG BITCOIN_VERSION=26.0

FROM --platform=$BUILDPLATFORM alpine:${ALPINE_VERSION} as test

RUN apk add \
        curl \
        netcat-openbsd

COPY tests /tests

ENTRYPOINT ["/bin/sh"]

EXPOSE 80


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


FROM build as external-mode

RUN chmod -x \
        /entrypoint-internal-mode.sh \
    && chmod +x \
        /entrypoint-external-mode.sh

ENTRYPOINT ["/entrypoint-external-mode.sh"]


FROM build as internal-mode

RUN chmod -x \
        /entrypoint-external-mode.sh \
    && chmod +x \
        /entrypoint-internal-mode.sh

ENTRYPOINT ["/entrypoint-internal-mode.sh"]

EXPOSE 8332/tcp
