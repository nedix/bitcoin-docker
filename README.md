# bitcoin-docker

A Docker container that runs [Bitcoin Core] in full or light (pruned) mode.
Containers in full mode synchronize with the Bitcoin network and broadcast transactions from light mode containers.
Containers in light mode are isolated from the public internet and communicate over an internal network with full mode
  containers.
The goal is to make wallets safer by keeping them isolated from the public internet.

## Configuration

### Environment Variables

| Variable           | Options         | Description                                                                                                                                                                                         |
|--------------------|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `MODE`             | `full`, `light` | Full mode containers communicate with the network to sync the blockchain and broadcast transactions. Light mode containers have RPC access enabled and should be isolated from the public internet. |
| `CONNECT_PEER`     |                 | Specify the full mode container that a light mode container should connect to, applies to light mode containers.                                                                                    |
| `RPC_USERNAME`     |                 | Username for RPC authentication, applies to light mode containers.                                                                                                                                  |
| `RPC_PASSWORD`     |                 | Password for RPC authentication, applies to light mode containers.                                                                                                                                  |
| `WEBHOOK_ENDPOINT` |                 | Endpoint to receive JSON POST requests of Bitcoin Core notifications.                                                                                                                               |

## Usage

### Docker Compose

Example usage in combination with [S3-NFS-Docker] for remote storage of blocks and data. Wallet information is kept in a
  local volume.

```yaml
version: "3.9"

services:
  bitcoin-full:
    image: ${COMPOSE_PROJECT_NAME}-bitcoin
    build:
      context: docker/images/bitcoin
      dockerfile: Dockerfile
    pull_policy: never
    environment:
      MODE: full
      CHAIN: '${BITCOIN_CHAIN}'
      WEBHOOK_ENDPOINT: 'http://api/webhook/bitcoin'
    networks:
      default:
      internal:
    volumes:
      - 'bitcoin-s3-nfs:/mnt/nfs'
    depends_on:
      bitcoin-s3-nfs:
        condition: service_healthy
    stop_grace_period: 5m

  bitcoin-light:
    image: ${COMPOSE_PROJECT_NAME}-bitcoin
    pull_policy: never
    environment:
      MODE: light
      CHAIN: '${BITCOIN_CHAIN}'
      CONNECT_PEER: bitcoin-full
      RPC_USERNAME: '${BITCOIN_RPC_USERNAME}'
      RPC_PASSWORD: '${BITCOIN_RPC_PASSWORD}'
      WEBHOOK_ENDPOINT: 'http://app/webhook/bitcoin'
    networks:
      internal:
        aliases:
          - bitcoin
    ports:
      - '${FORWARD_BITCOIN_RPC_PORT}:8332'
    volumes:
      - 'bitcoin:/var/bitcoin'
      - 'bitcoin-s3-nfs:/mnt/nfs'
    depends_on:
      bitcoin-full:
        condition: service_started
      bitcoin-s3-nfs:
        condition: service_healthy
    deploy:
      replicas: 2
    stop_grace_period: 5m

  bitcoin-s3-nfs:
    image: ghcr.io/nedix/s3-nfs-docker:1.0.4
    cap_add:
      - SYS_ADMIN
    devices:
      - /dev/fuse:/dev/fuse:rwm
    environment:
      S3_NFS_BUCKET: '${BITCOIN_S3_BUCKET}'
      S3_NFS_ENDPOINT: '${BITCOIN_S3_ENDPOINT}'
      S3_NFS_ACCESS_KEY_ID: '${BITCOIN_S3_ACCESS_KEY_ID}'
      S3_NFS_SECRET_ACCESS_KEY: '${BITCOIN_S3_SECRET_ACCESS_KEY}'
    networks:
      default:
      internal:
    ports:
      - '${FORWARD_BITCOIN_NFS_PORT}:2049'

networks:
  default:
    name: ${COMPOSE_PROJECT_NAME}
  internal:
    internal: true

volumes:
  bitcoin:
  bitcoin-s3-nfs:
    driver_opts:
      type: 'nfs'
      o: 'vers=4,addr=localhost,port=${FORWARD_BITCOIN_NFS_PORT},rw'
      device: ':/'
```

```dotenv
BITCOIN_CHAIN=test
BITCOIN_RPC_USERNAME=
BITCOIN_RPC_PASSWORD=
BITCOIN_S3_BUCKET=
BITCOIN_S3_ENDPOINT=
BITCOIN_S3_ACCESS_KEY_ID=
BITCOIN_S3_SECRET_ACCESS_KEY=
FORWARD_BITCOIN_NFS_PORT=2049
FORWARD_BITCOIN_RPC_PORT=8332
```

[Bitcoin Core]: https://github.com/bitcoin/bitcoin
[S3-NFS-Docker]: https://github.com/nedix/s3-nfs-docker
