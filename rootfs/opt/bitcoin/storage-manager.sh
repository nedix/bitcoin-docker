#!/usr/bin/env sh

DATA_DIRECTORY="/var/bitcoin"
WALLET_DIRECTORY="${DATA_DIRECTORY}/wallets"

get_log_file() {
    touch "${DATA_DIRECTORY}/bitcoind.log"
    echo "${DATA_DIRECTORY}/bitcoind.log"
}

get_blocks_directory() {
    if [ -e "${DATA_DIRECTORY}/blocks_directory" ]; then
        STORAGE_DIRECTORY=$(cat "${DATA_DIRECTORY}/blocks_directory")
    else
        STORAGE_DIRECTORY="/mnt/nfs/$(uuidgen)"
        echo "$STORAGE_DIRECTORY" > "${DATA_DIRECTORY}/blocks_directory"
        chmod a-w "${DATA_DIRECTORY}/blocks_directory"
        mkdir -p "$STORAGE_DIRECTORY"
    fi

    echo "$STORAGE_DIRECTORY"
}

get_data_directory() {
    mkdir -p "$DATA_DIRECTORY"
    echo "$DATA_DIRECTORY"
}

get_wallet_directory() {
    mkdir -p "$WALLET_DIRECTORY"
    echo "$WALLET_DIRECTORY"
}
