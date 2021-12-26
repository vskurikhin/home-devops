#!/bin/sh
virt-install \
              --hvm \
              --name k8s000 \
              --ram 5632 \
              --cpu host-passthrough \
              --vcpus maxvcpus=2,cpuset="0-1" \
              --file /dev/all2a/k8s000.rune.ru \
              --nographics \
              --network network=bridged-network,bridge=xenbr88,mac=00:00:00:00:88:80 \
              --location http://192.168.88.69/AlmaLinux-8.5-x86_64-minimal/ \
              --os-type linux --os-variant=centos8 \
              --extra-args=\
"ks=http://192.168.88.69/k8s000.ks ksdevice=enp1s0 ip=192.168.88.80 netmask=255.255.255.0 gateway=192.168.88.1 lang=en_US console=ttyS0"
