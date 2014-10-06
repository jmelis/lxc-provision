#!/bin/bash

TEMPLATE=$1
NAME=$2
IP=$3

################################################################################
# Find an empty IP
################################################################################

if [ -z "$IP" ]; then
    IPS=$(sed -n "/^172\.16\.77\.3.*lxc/s/\blxc-.*$//p" /etc/hosts)
    IP=$(
        for i in `seq 0 9`; do
            test_ip=172.16.77.3${i}
            if ! echo -n "$IPS" | grep -q "\b${test_ip}\b"; then
                echo $test_ip
                break
            fi
        done
    )
fi

if [ -z "$IP" ]; then
    echo "IP not supplied and no available ones" >&2
    exit 1
fi

################################################################################
# Other parameters
################################################################################

MAC=$(ip_to_hex $IP | tr A-Z a-z)

REPO=$(cd $(dirname `realpath $0`)/..; pwd)
CONFIG=/var/lib/lxc/$NAME/config
ROOTFS=/var/lib/lxc/$NAME/rootfs

################################################################################
# Clone Container
################################################################################

sudo lxc-clone $TEMPLATE $NAME

################################################################################
# LXC Container Configuration File
################################################################################

sudo sed -i '/^lxc.network.ipv4 =/d' $CONFIG

cat <<EOF | sudo tee -a $CONFIG > /dev/null
lxc.network.ipv4=$IP/24
EOF

################################################################################
# Other System Files
################################################################################

sudo sed -i.bk.$(date '+%Y%m%d%H%M') "/$IP/d" /etc/hosts
echo "$IP $NAME" | sudo tee -a /etc/hosts > /dev/null

################################################################################
# Start Container
################################################################################

echo sudo lxc-start -d -n $NAME
