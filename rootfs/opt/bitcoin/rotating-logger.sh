#!/usr/bin/env sh

LOG_FILE="$1"

while IFS= read -r LINE; do
    echo "$LINE"

    if [ -z "$TIMEOUT" ]; then
        LOG_LINES=$(cat "$LOG_FILE")
        TIMEOUT=$(( $(date +%s) + 1 ))
    fi

    if [ $(date +%s) -lt "$TIMEOUT" ]; then
        LOG_LINES="${LOG_LINES}\n${LINE}"
        continue
    fi

    echo -n "$LOG_LINES" | tail -n 100 | sed -e "w ${LOG_FILE}" > /dev/null 2>&1

    LOG_LINES=""
    TIMEOUT=""
done
