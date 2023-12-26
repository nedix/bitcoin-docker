#!/usr/bin/env sh

get_storage_dir() {
    if [ -e /var/bitcoin/storage_id ]; then
        STORAGE_DIR=$(cat /var/bitcoin/storage_id)
    else
        STORAGE_DIR="/mnt/nfs/$(uuidgen)"
        echo "$STORAGE_DIR" > /var/bitcoin/storage_id
        chmod a-w /var/bitcoin/storage_id
    fi

    echo "$STORAGE_DIR"
}
