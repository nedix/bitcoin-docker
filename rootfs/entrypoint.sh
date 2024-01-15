#!/usr/bin/env sh

set -e

. /opt/bitcoin/manage-storage.sh

: ${BLOCKS_DIRECTORY:="$(get_blocks_directory)"}
: ${DATA_DIRECTORY:="$(get_data_directory)"}
: ${DB_CACHE_SIZE:=1024}
: ${EXTERNAL_PEER:="bitcoin-external"}
: ${LOG_FILE:="${DATA_DIRECTORY}/bitcoind.log"}
: ${MODE:=""}
: ${WALLET_DIRECTORY:="$(get_wallet_directory)"}

ARGS=" \
    --blocksdir=${BLOCKS_DIRECTORY} \
    --chain=${CHAIN} \
    --conf=/etc/bitcoin/bitcoin.conf \
    --datadir=${DATA_DIRECTORY} \
    --dbcache=${DB_CACHE_SIZE} \
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

if grep -q "-reindex" "$LOG_FILE"; then
    ARGS="$ARGS --reindex"
fi

exec stdbuf -oL /usr/local/bin/bitcoind ${ARGS} 2>&1 | while IFS= read -r LINE; do
    echo "$LINE"
    sed -i -e '1,1000d' -e "\$a${LINE}" "$LOG_FILE"
    sleep 1
done
