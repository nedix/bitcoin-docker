# bitcoin-docker

A Docker container that runs [Bitcoin Core] in an external mode or in an internal (pruned) mode.
Containers in external mode synchronize with the Bitcoin network and broadcast transactions from internal mode
 containers.
Containers in internal mode are isolated from the public internet and communicate over an internal network with external
 mode containers.
The goal is to make wallets safer by keeping them isolated from the public internet.


## Makefile

Docker Compose is required for running tasks from the makefile.

Run the [`make setup`](#setup) command to get started.

### Up

Start the application.

```bash
$ make up
```

### Down

Stop the application.

```bash
$ make down
```

### Setup

Setup and start the application. It will copy the .env.example file to .env if it could not be found.

```bash
$ make setup
```

### Destroy

Stop the application and remove containers and volumes.

```bash
$ make destroy
```

### Fresh

Recreate the application.

```bash
$ make fresh
```

### Test

Test the application.

```bash
$ make test
```


## Docker

### Build arguments


### Environment variables

| Variable                   | Description                                                                               |
|----------------------------|-------------------------------------------------------------------------------------------|
| `EXTERNAL_PEER`            | Hostname of an external mode container that an internal mode container should connect to. |
| `RPC_USERNAME`             | Username for RPC authentication.                                                          |
| `RPC_PASSWORD`             | Password for RPC authentication.                                                          |
| `WEBHOOK_ENDPOINT`         | Endpoint to receive JSON POST requests of Bitcoin Core notifications.                     |
| `FORWARD_BITCOIN_RPC_PORT` | Public port to the RPC for both external mode and internal mode containers.               |


## Docker Compose

### Environment variables

| Variable                     | Description     |
|------------------------------|-----------------|
| `S3_ENDPOINT`                |                 |
| `S3_BUCKET`                  |                 |
| `S3_ACCESS_KEY_ID`           |                 |
| `S3_SECRET_ACCESS_KEY`       |                 |
| `FORWARD_S3_NFS_PORT`        | (default: 2049) |


[Bitcoin Core]: https://github.com/bitcoin/bitcoin
[S3-NFS-Docker]: https://github.com/nedix/s3-nfs-docker
