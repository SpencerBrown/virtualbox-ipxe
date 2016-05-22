#!/usr/bin/env bash

docker run -it --name=virtio-ipxe virtio-ipxe true
mkdir -p bin
docker cp virtio-ipxe:/ipxe/src/bin/virtio-net.isarom bin/virtio-net.isarom
docker rm virtio-ipxe