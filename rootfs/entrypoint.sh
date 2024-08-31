#!/usr/bin/env sh

set -e

: ${BLOCKS_DIRECTORY:="/var/bitcoin/"}
: ${CHAIN:="main"}
: ${DATA_DIRECTORY:="/mnt/datasource/"}
: ${DB_CACHE_SIZE:=1024}
: ${EXTERNAL_PEER:=""}
: ${LOG_FILE:="/var/bitcoin/bitcoind.log"}
: ${MAX_CONNECTIONS:=125}
: ${MODE:="external"}
: ${RPC_PASSWORD:=""}
: ${RPC_USERNAME:=""}
: ${WALLET_DIRECTORY:="/var/bitcoin/wallets/"}

mkdir -p \
    "$BLOCKS_DIRECTORY" \
    "$DATA_DIRECTORY" \
    "$WALLET_DIRECTORY"

ARGS=" \
    --blocksdir=${BLOCKS_DIRECTORY} \
    --chain=${CHAIN} \
    --conf=/etc/bitcoin/bitcoin.conf \
    --datadir=${DATA_DIRECTORY} \
    --dbcache=${DB_CACHE_SIZE} \
    --maxconnections=${MAX_CONNECTIONS} \
    --printtoconsole=1 \
    --upnp=0 \
    --whitelist=172.16.0.0/12 \
"

case "$MODE" in
    external)
        ARGS="$ARGS \
            --disablewallet=1 \
            --txindex=1 \
            --walletbroadcast=0 \
        "
        ;;
    internal)
        ARGS="$ARGS \
            --connect=${EXTERNAL_PEER} \
            --discover=0 \
            --dnsseed=0 \
            --listen=0 \
            --prune=550 \
            --rpcpassword=${RPC_PASSWORD} \
            --rpcuser=${RPC_USERNAME} \
            --walletdir=${WALLET_DIRECTORY} \
            --zmqpubrawblock=tcp://0.0.0.0:28332 \
            --zmqpubrawtx=tcp://0.0.0.0:28333 \
        "
        ;;
    *)
        echo "Invalid mode '$MODE'."
        exit 1
        ;;
esac

if \
    grep -q "-reindex" "$LOG_FILE" \
    || grep -q "Errors in block header" "$LOG_FILE" \
; then
    ARGS="$ARGS --reindex"
fi

test -p /tmp/fifo || mkfifo /tmp/fifo

grep ".*" --line-buffered < /tmp/fifo | /opt/bitcoin/rotating-logger.sh "$LOG_FILE" &

exec /usr/local/bin/bitcoind $ARGS > /tmp/fifo 2>&1
