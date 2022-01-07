resource resource1 {
  on all1.rune.ru {
    device    /dev/drbd1;
    disk      /dev/mapper/all1b-drbd01;
    address   192.168.88.69:7789;
    meta-disk internal;
  }
  on all2.rune.ru {
    device    /dev/drbd1;
    disk      /dev/mapper/all2b-drbd01;
    address   192.168.88.70:7789;
    meta-disk internal;
  }
}
