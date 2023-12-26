#!/usr/bin/env sh

set -e

if [ "$MODE" != "full" && "$MODE" != "light" ]; then
    echo "\$MODE should be set to 'full' or 'light'."
    exit 1
fi

if [ -e /var/bitcoin/storage_id ]; then
    STORAGE_DIR=$(cat /var/bitcoin/storage_id)
else
    STORAGE_DIR="/mnt/nfs/$(uuidgen)"
    echo $STORAGE_DIR > /var/bitcoin/storage_id
    chmod a-w /var/bitcoin/storage_id
fi

BLOCKS_DIR="${STORAGE_DIR}/blocks"
DATA_DIR="${STORAGE_DIR}/data"
WALLET_DIR="/var/bitcoin/wallets"

mkdir -p \
    "$BLOCKS_DIR" \
    "$DATA_DIR" \
    "$WALLET_DIR"

ARGS=" \
    --printtoconsole=1 \
    --conf=/etc/bitcoin/bitcoin.conf \
    --chain=${CHAIN} \
    --blocksdir=${BLOCKS_DIR} \
    --datadir=${DATA_DIR} \
    --upnp=0 \
    --whitelist=172.16.0.0/12 \
"

if [ $MODE = "full" ]; then
    if [ -n "$RPC_USERNAME" || -n "$RPC_PASSWORD" ]; then
        echo "\$RPC_USERNAME and \$RPC_PASSWORD are prohibited when \$MODE is set to 'full'."
        exit 1
    fi

    ARGS="${ARGS} \
        --disablewallet=1 \
        --txindex=1 \
        --walletbroadcast=0 \
    "
fi

if [ $MODE = "light" ]; then
    if [ -z "$RPC_USERNAME" || -z "$RPC_PASSWORD" ]; then
        echo "\$RPC_USERNAME and \$RPC_PASSWORD are required when \$MODE is set to 'light'."
        exit 1
    fi

    ARGS="${ARGS} \
        --connect=${CONNECT_PEER} \
        --prune=550 \
        --discover=0 \
        --listen=0 \
        --dnsseed=0 \
        --walletdir=${WALLET_DIR} \
        --rpcuser=${RPC_USERNAME} \
        --rpcpassword=${RPC_PASSWORD} \
    "
fi

exec /usr/local/bin/bitcoind ${ARGS}
