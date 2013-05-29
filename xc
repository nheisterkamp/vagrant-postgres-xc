#!/bin/bash

echo "vagrant-postgres-xc"
echo ""
echo "Boot your own Postgres-XC cluster"
echo ""
echo "Usage:"
echo "- xc config <#coordinators> <#datanodes>"
echo "- xc start/up/boot"
echo "- xc restart/reload/reboot"
echo "- xc stop/halt"
echo "- xc provision"
echo "- xc status"
echo ""
echo "Example:"
echo "  xc config 1 4 && xc start"
echo ""

CFGFILE="./.config"
CMD=$1

touch $CFGFILE
. $CFGFILE

if [ "$CMD" == "config" ]; then
	if [ $# -lt 3 ]; then
		echo "Please specify <#coordinators> <#datanodes>" >&2
		exit 1
	fi

	declare -i COORDINATORS
	declare -i DATANODES
	COORDINATORS=$2
	DATANODES=$3

	declare -p COORDINATORS DATANODES >$CFGFILE

	echo "Config saved to .config $COORDINATORS $DATANODES"

	exit 0
fi

if [ -z $COORDINATORS ] || [ -z $DATANODES ]; then
	echo "Run xc config <#coordinators> <#datanodes>" >&2
	exit 1
fi

COORDINATOR_NAMES="/coordinator[1-${COORDINATORS}]/"
DATANODES_NAMES="/datanode[1-${DATANODES}]/"

if [ "$CMD" == "boot" ] || [ "$CMD" == "start" ]; then
	echo "Booting cluster"
	echo ""

	echo "With:"
	echo "- ${COORDINATORS} coordinators"
	echo "- ${DATANODES} datanodes"
	echo ""
	vagrant up $COORDINATOR_NAMES
	vagrant up $DATANODES_NAMES
elif [ "$CMD" == "reboot" ] || [ "$CMD" == "restart" ]; then
	vagrant reload $COORDINATOR_NAMES $DATANODES_NAMES
elif [ "$CMD" == "halt" ] || [ "$CMD" == "stop" ]; then
	vagrant up $COORDINATOR_NAMES
	vagrant up $DATANODES_NAMES
elif [ "$CMD" == "status" ]; then
	vagrant status $COORDINATOR_NAMES
	vagrant status $DATANODES_NAMES
elif [ "$CMD" == "provision" ]; then
	vagrant provision $COORDINATOR_NAMES
	vagrant provision $DATANODES_NAMES
fi
