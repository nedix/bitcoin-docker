#!/usr/bin/env sh

. /opt/bitcoin/manage-volumes.sh

set -e

STORAGE_DIR=$(get_storage_dir)
BLOCKS_DIR="${STORAGE_DIR}/blocks"
DATA_DIR="${STORAGE_DIR}/data"

mkdir -p \
    "$BLOCKS_DIR" \
    "$DATA_DIR"

ARGS=" \
    --printtoconsole=1 \
    --conf=/etc/bitcoin/bitcoin.conf \
    --chain=${CHAIN} \
    --blocksdir=${BLOCKS_DIR} \
    --datadir=${DATA_DIR} \
    --disablewallet=1 \
    --txindex=1 \
    --upnp=0 \
    --walletbroadcast=0 \
    --whitelist=172.16.0.0/12 \
"

exec /usr/local/bin/bitcoind ${ARGS}
