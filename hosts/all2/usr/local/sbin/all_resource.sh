#!/bin/bash
# This script will be executed during boot.

remote=all1.rune.ru
dns_vip=192.168.88.10
nfs_vip=192.168.88.11

df=/usr/bin/df
drbdadm=/usr/sbin/drbdadm
grep=/usr/bin/grep
ip=/usr/sbin/ip
mount=/usr/bin/mount
ssh=/usr/bin/ssh
systemctl=/usr/bin/systemctl
systemctl_opts='--no-pager'
umount=/usr/bin/umount

start_vip() {
  [ "x$1" != "x" ] && $ip address add $1/24 dev xenbr88 || return 1
}

stop_vip() {
  [ "x$1" != "x" ] && $ip address del $1/24 dev xenbr88 || return 1
}

start_dnsmasq() {
  $ip address show |
  grep $dns_vip ||
  (start_vip $dns_vip && $systemctl $systemctl_opts restart dnsmasq.service)
}

start_drbd_and_nfs() {
  $drbdadm primary resource1 &&
  if $mount /dev/drbd1
  then
    $ip address show | $grep $nfs_vip || start_vip $nfs_vip
    $systemctl $systemctl_opts start nfs-server.service
  fi
}

stop_nfs_and_drbd() {
  $systemctl $systemctl_opts stop nfs-server.service
  if $df | $grep /dev/drbd1
  then
    $umount -f /dev/drbd1
  fi
  $drbdadm secondary resource1
}

switch_drbd_and_nfs() {
  if $ssh -o ConnectTimeout=3 $remote hostname 2>/dev/null
  then
    $ssh $remote '/usr/local/sbin/all_resource.sh stop'
  fi
  start_dnsmasq
  start_drbd_and_nfs
}

status() {
  $systemctl $systemctl_opts status dnsmasq.service
  $systemctl $systemctl_opts status drbd.service
  $drbdadm status
  $systemctl $systemctl_opts status nfs-server.service
}

case "$1" in
    start)
      start_dnsmasq
      start_drbd_and_nfs
      exit 0
    ;;
    stop)
      stop_vip $nfs_vip
      stop_nfs_and_drbd
      stop_vip $dns_vip
      exit 0
    ;;
    switch)
      switch_drbd_and_nfs
      exit 0
    ;;
    status)
      status
      exit 0
    ;;
esac
exit 1
