FROM debian
MAINTAINER Spencer Brown

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get -y install build-essential git liblzma-dev

RUN git clone git://git.ipxe.org/ipxe.git

RUN printf "#ifndef IMAGE_BZIMAGE\n#define IMAGE_BZIMAGE\n#endif\n" >> /ipxe/src/config/general.h

WORKDIR /ipxe/src
RUN    make -j 4 CONFIG=vbox bin/virtio-net.isarom