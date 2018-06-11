# Litecoin Docker container

A Docker container running [Litecoin][litecoin] as a service and
exposing the REST API.

## Prerequisites

Install [Docker][docker], e.g. on Debian/Ubuntu based systems

    sudo apt install docker.io

## Configuration

Modify `docker/litecoin.conf` according to your environment. 
Configure `rpcallowip=...` to allow the client/daemon to accept
RPC connections outside the localhost and set an RPC username (`rpcuser`)
and password (`rpcpassword`).

Make sure your config file includes the following line:

    txindex=1

## Usage

Building the docker container (tagged GitHub version of Litecoin in `docker/Makefile`):

    ./docker/build.sh

Starting the container:

    ./docker/start.sh DATA_DIR

Attaching to the container:

    ./docker/attach.sh

Showing the Bitcoin log file:

    ./docker/show_log.sh


[litecoin]: https://litecoin.org
[docker]: https://www.docker.com
