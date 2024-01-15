# [bitcoin]-docker

Docker images to run [Bitcoin Core][bitcoin] in full or pruned mode.

## Synopsis

Two separate ways to run [Bitcoin] in either an external mode or in an internal (pruned) mode.
Containers in external mode synchronize with the Bitcoin network and broadcast transactions from internal mode containers.
Containers in internal mode are isolated from the public internet and communicate over an internal network with external mode containers.
The goal is to make wallets safer by keeping them isolated from the public internet.

<hr>

## Setup 

### Environment variables

Create an `.env` file or copy it from `.env.example` and configure it to your needs.

#### Docker container

| Variable                   | Description                                                                               |
|----------------------------|-------------------------------------------------------------------------------------------|
| `EXTERNAL_PEER`            | Hostname of an external mode container that an internal mode container should connect to. |
| `RPC_USERNAME`             | Username for RPC authentication.                                                          |
| `RPC_PASSWORD`             | Password for RPC authentication.                                                          |
| `WEBHOOK_ENDPOINT`         | Endpoint to receive JSON POST requests of Bitcoin Core notifications.                     |
| `FORWARD_BITCOIN_RPC_PORT` | Public port to the RPC for both external mode and internal mode containers.               |

<hr>

## Usage

#### Up

Start the application.

```shell
make up
```

#### Down

Stop the application.

```shell
make down
```

#### Setup

Setup and start the application. It will copy the .env.example file to .env if it could not be found.

```shell
make setup
```

#### Destroy

Stop the application and remove containers and volumes.

```shell
make destroy
```

#### Fresh

Recreate the application.

```shell
make fresh
```

#### Test

Test the application.

```shell
make test
```

<hr>

## Attribution

Powered by [Bitcoin Core][bitcoin].

[bitcoin]: https://github.com/bitcoin/bitcoin
[S3-NFS-Docker]: https://github.com/nedix/s3-nfs-docker
