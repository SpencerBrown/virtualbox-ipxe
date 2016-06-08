# DO NOT USE -- this project is broken right now. 

The problem is that the `virtio-net.isarom` binary is now too large for VirtualBox to use as the NIC boot ROM. The maximum size is 57344 bytes, and the binary is now 58368 bytes. 

Unfortunately, VirtualBox does not give you a visible error or warning in this case. 
It logs the issue in a file in the Logs directory of the VM, and silently uses its own iPXE binary. 
So it appears to you like there is no bzimage support in the new binary.

I am working on an alternate approach to the problem and have it working on my local machine. 
The solution is to chainload from the iPXE in VirtualBox's boot ROM to a more capable iPXE with bzimage support. 
I will be posting this in a repo soon.

# virtualbox-ipxe
Custom IPXE build for VirtualBox with support for booting CoreOS

# Overview

## User story

As a VirtualBox user, I want to boot a virtual machine using IPXE network booting. My operating system is CoreOS.

## The technical issue

VirtualBox comes with a virtual LAN Boot ROM that is a build of IPXE, with support for HTTP, but not for bzImage.
CoreOS ships their PXE boot initramfs in cpio.bz format.
Therefore, network booting CoreOS on VirtualBox using IPXE fails.

The VirtualBox developers have a limit on the size of their IPXE boot ROM image. 
They have declined to add bzImage support for this reason.
See [this VirtualBox bug report](https://www.virtualbox.org/ticket/15159)

VirtualBox provides an [Extension Pack](https://www.virtualbox.org/manual/ch01.html#intro-installing) which includes the Intel PXE Boot ROM. 

## The solution provided by this repo

Create a custom build of the VirtualBox IPXE boot ROM, which includes the bzImage support.
Support only the `virtio-net` NIC type, to save space and keep under the size limit.

As long as you define your VirtualBox network adapter used for IPXE booting as `Paravirtualized Network (virtio-net)`, you will be able to boot CoreOS under VirtualBox using IPXE.

# Getting and using the IPXE boot ROM

A recent build of the boot ROM is available from this repo: `bin/virtio-net.isarom`. 

Copy that file to a known location on the machine running VirtualBox. Then:

```bash
vboxmanage setextradata global VBoxInternal/Devices/pcbios/0/Config/LanBootRom <absolute-path>/virtio-net.isarom
```

# Building a new IPXE boot ROM

## Setup

In an environment where you have Docker available, clone this repo and `cd` to the repo root.

## Build

```bash
./build-virtio.sh
```

Creates a Docker image including a build of the IPXE boot ROM as described above.

## Copy IPXE boot ROM

```bash
./copy-virtio.sh
```

The newly built boot ROM file is saved in this repo directory structure as `bin/virtio-net.isarom`.

# Notes

The max size boot rom is 57344 bytes long.