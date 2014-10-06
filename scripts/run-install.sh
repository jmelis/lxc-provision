#!/bin/bash

NAME=$1
COMMIT=${2-master}

[ -z "$NAME" ] && echo "Invalid Arg" && exit 1

cat install-opennebula.sh | ssh oneadmin@${NAME} bash -s ${COMMIT}

