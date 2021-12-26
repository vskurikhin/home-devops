#!/bin/sh
virsh setmem --domain $1 --size $2 --current
