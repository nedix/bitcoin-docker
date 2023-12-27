#!/usr/bin/env sh

export DOCKER_COMPOSE_CMD="docker compose -f docker-compose.test.yml --env-file .env.test"

setup() {
    if [ -z "$TESTCASE_INITIALIZED" ]; then
        ${DOCKER_COMPOSE_CMD} up --no-deps --wait -d minio
        ${DOCKER_COMPOSE_CMD} exec minio sh -c " \
            mc mb 'data/minio/${MINIO_BUCKET}' \
            && mc anonymous set none 'data/minio/${MINIO_BUCKET}' \
        "
        ${DOCKER_COMPOSE_CMD} up --wait -d test
        export TESTCASE_INITIALIZED=true
    fi
}

destroy() {
    ${DOCKER_COMPOSE_CMD} kill --remove-orphans
    ${DOCKER_COMPOSE_CMD} rm --volumes --force
    unset TESTCASE_INITIALIZED
}

assert_success() {
    set -e
    echo "Testing '${1##*/}'..."
    ${DOCKER_COMPOSE_CMD} run --rm -t test "$@" > /dev/null
    echo "Good exit from '${1##*/}'."
}
