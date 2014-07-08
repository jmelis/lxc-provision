#!/bin/bash

TOPDIR=$(cd $(dirname `realpath $0`)/..; pwd)

NAME=$1
IP=$2
COMMIT=${3-master}

# Provision an empty container
$TOPDIR/bin/lxc-centos.sh $NAME $IP

# Start the container
sudo lxc-start -d -n $NAME
sleep 10

# Install OpenNebula build dependencies, users, and developer tools (vim, etc)
cd $TOPDIR/ansible_playbooks
ansible-playbook -i ${NAME}, site.yml

# Compile and Install OpenNebula
cd $TOPDIR/scripts
cat install-opennebula.sh | ssh oneadmin@${NAME} bash -s $COMMIT
