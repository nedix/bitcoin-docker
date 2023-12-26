#!/usr/bin/env sh

if [ -n "$WEBHOOK_ENDPOINT" ]; then
    curl -sSX POST "$WEBHOOK_ENDPOINT" -d "{\"host\": \"${HOSTNAME}\", \"event\": \"$1\", \"payload\": \"$2\"}" -H 'Content-Type: application/json'
fi
