#! /usr/bin/env bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/config.sh
{
	rclone --config=$RCLONE_CONFIG copy /var/lib/elasticsearch/ dochausersync:/dochauser_mount/elasticsearch/
} >> $LOG_FILE;
