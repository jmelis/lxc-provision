#!/bin/bash

NAME=$1
IP=$2

if [ -z "$NAME" -o -z "$IP" ]; then
    echo "Invalid number of arguments."
    exit 1
fi

MAC=$(ip_to_hex $IP | tr A-Z a-z)

REPO=$(cd $(dirname `realpath $0`)/..; pwd)
CONFIG=/var/lib/lxc/$NAME/config
ROOTFS=/var/lib/lxc/$NAME/rootfs

sudo lxc-create -t download -n $NAME -- -d centos -r 6 -a amd64

sudo sed -i '/^lxc.network.type = empty/d' $CONFIG

cat <<EOF | sudo tee -a $CONFIG > /dev/null
lxc.network.type=veth
lxc.network.link=br0
lxc.network.flags=up
lxc.network.hwaddrdd=$MAC
lxc.network.ipv4=$IP/24
EOF

sudo sed -i.bk.$(date '+%Y%m%d%H%M') "/$IP/d" /etc/hosts
echo "$IP $NAME" | sudo tee -a /etc/hosts > /dev/null

sudo mkdir -p $ROOTFS/root/.ssh
cat $HOME/.ssh/id_dsa.pub | sudo tee -a $ROOTFS/root/.ssh/authorized_keys > /dev/null
sudo chown -R root:root $ROOTFS/root/.ssh/

sudo sed -i 's/dhcp/none/' $ROOTFS/etc/sysconfig/network-scripts/ifcfg-eth0

sudo sed -i 's/^root.*/root:!:15800::::::/' $ROOTFS/etc/shadow

echo "${NAME}" >> $REPO/ansible_playbooks/hosts
