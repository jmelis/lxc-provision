#!/bin/bash

TOPDIR=$(cd $(dirname `realpath $0`)/..; pwd)

NAME=$1
IP=$2
COMMIT=${3-master}

$TOPDIR/bin/lxc-centos.sh $NAME $IP
sudo lxc-start -d -n $NAME

sleep 10

cd $TOPDIR/ansible_playbooks
ansible-playbook -i ${NAME}, site.yml

cd $TOPDIR/scripts
cat install-opennebula.sh | ssh oneadmin@${NAME} bash -s $COMMIT


