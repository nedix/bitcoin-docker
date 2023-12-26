#!/usr/bin/env sh

. /opt/bitcoin/manage-volumes.sh

set -e

STORAGE_DIR=$(get_storage_dir)
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
    --connect=${CONNECT_PEER} \
    --discover=0 \
    --dnsseed=0 \
    --listen=0 \
    --prune=550 \
    --rpcpassword=${RPC_PASSWORD} \
    --rpcuser=${RPC_USERNAME} \
    --upnp=0 \
    --walletdir=${WALLET_DIR} \
    --whitelist=172.16.0.0/12 \
"

exec /usr/local/bin/bitcoind ${ARGS}
