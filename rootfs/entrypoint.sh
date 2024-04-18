#!/usr/bin/env sh

set -e

. /opt/bitcoin/storage-manager.sh

: ${BLOCKS_DIRECTORY:="$(get_blocks_directory)"}
: ${CHAIN:="main"}
: ${DATA_DIRECTORY:="$(get_data_directory)"}
: ${DB_CACHE_SIZE:=1024}
: ${EXTERNAL_PEER:=""}
: ${LOG_FILE:="$(get_log_file)"}
: ${MAX_CONNECTIONS:=125}
: ${MODE:="external"}
: ${RPC_PASSWORD:=""}
: ${RPC_USERNAME:=""}
: ${WALLET_DIRECTORY:="$(get_wallet_directory)"}

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
