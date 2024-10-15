# [bitcoin][Bitcoin Core]-container

Container to run Bitcoin Core in full or pruned mode.

## Synopsis

This container can be used to run Bitcoin Core in either an external mode or in an internal (pruned) mode.
Containers in external mode synchronize with the Bitcoin network and broadcast transactions from internal mode containers.
Containers in internal mode are isolated from the public internet and communicate over an internal network with external mode containers.
The goal is to make wallets safer by keeping them isolated from the public internet.

## Configuration

| Environment variable       | Description                                                                               |
|----------------------------|-------------------------------------------------------------------------------------------|
| `EXTERNAL_PEER`            | Hostname of an external mode container that an internal mode container should connect to. |
| `RPC_USERNAME`             | Username for RPC authentication.                                                          |
| `RPC_PASSWORD`             | Password for RPC authentication.                                                          |
| `WEBHOOK_ENDPOINT`         | Endpoint to receive JSON POST requests of Bitcoin Core notifications.                     |
| `FORWARD_BITCOIN_RPC_PORT` | Public port to the Bitcoin Core RPC server.                                               |

## Attribution

- [Bitcoin Core] ([License](https://raw.githubusercontent.com/bitcoin/bitcoin/master/COPYING))

[Bitcoin Core]: https://github.com/bitcoin/bitcoin
