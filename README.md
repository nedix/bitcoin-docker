# bitcoin-docker

A Docker container that runs [Bitcoin Core] in full or light (pruned) mode.
Containers in full mode synchronize with the Bitcoin network and broadcast transactions from light mode containers.
Containers in light mode are isolated from the public internet and communicate over an internal network with full mode
  containers.
The goal is to make wallets safer by keeping them isolated from the public internet.

## Configuration

### Environment Variables

| Variable           | Description                                                                                                      |
|--------------------|------------------------------------------------------------------------------------------------------------------|
| `CONNECT_PEER`     | Specify the full mode container that a light mode container should connect to, applies to light mode containers. |
| `RPC_USERNAME`     | Username for RPC authentication.                                                                                 |
| `RPC_PASSWORD`     | Password for RPC authentication.                                                                                 |
| `WEBHOOK_ENDPOINT` | Endpoint to receive JSON POST requests of Bitcoin Core notifications.                                            |

## Usage

Docker is required for running tasks from the makefile.

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

Setup and start the application. It will copy the .env.example file to .env if an environment file could not be found.

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

### Minio S3

Recreate the minio bucket.

```bash
$ make s3-fresh
```


[Bitcoin Core]: https://github.com/bitcoin/bitcoin
[S3-NFS-Docker]: https://github.com/nedix/s3-nfs-docker
