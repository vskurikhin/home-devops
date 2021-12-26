lang en_US
keyboard us
timezone Europe/Moscow --isUtc
rootpw 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' --iscrypted
#platform x86, AMD64, or Intel EM64T
reboot
text
url --url=http://192.168.88.69/AlmaLinux-8.5-x86_64-minimal/
bootloader --location=mbr --append="rhgb quiet crashkernel=auto"
zerombr
clearpart --all --initlabel
autopart
network --device=enp1s0 --hostname=pgs002 --bootproto=static --ip=192.168.88.76 --netmask=255.255.255.0 --gateway=192.168.88.1 --nameserver=192.168.88.10
selinux --enforcing
firewall --enabled --http --ssh
skipx
firstboot --disable
%post
setsebool -P ssh_sysadm_login=on
groupadd -g 1304 vnsk
useradd -u 1304 -g vnsk -G root,adm,wheel -m -k /etc/skel -c "Victor N. Skurikhin" -s /bin/bash -Z sysadm_u vnsk
echo 'vnsk:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' | chpasswd -e
echo 'vnsk ALL=(ALL) ALL' > /etc/sudoers.d/vnsk
%end
%packages
@^minimal-environment
policycoreutils
%end
