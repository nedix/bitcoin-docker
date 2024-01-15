#!/usr/bin/env sh

ACCUMULATOR=""

while IFS= read -r LINE; do
    echo "$LINE"

    if [ -z "$TIMEOUT" ]; then
        TIMEOUT=$(( $(date +%s) + 1 ))
    fi

    if [ $(date +%s) -lt $TIMEOUT ]; then
        ACCUMULATOR="${ACCUMULATOR}${LINE}\n"
        continue
    fi

    sed -i -e '1,1000d' -e "\$a$ACCUMULATOR" "$LOG_FILE"

    ACCUMULATOR=""
    TIMEOUT=""
done
