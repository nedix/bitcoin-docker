#!/usr/bin/env sh

LOG_FILE="$1"

while IFS= read -r LINE; do
    echo "$LINE"

    if [ -z "$TIMEOUT" ]; then
        TIMEOUT=$(( $(date +%s) + 1 ))
    fi

    if [ $(date +%s) -lt $TIMEOUT ]; then
        LOG_LINES="${LOG_LINES:-}\n${LINE}"
        continue
    fi

    (cat "$LOG_FILE"; echo -n "$LOG_LINES") \
        | tail -n 100 \
        | sed -e "w ${LOG_FILE}"

    LOG_LINES=""
    TIMEOUT=""
done
