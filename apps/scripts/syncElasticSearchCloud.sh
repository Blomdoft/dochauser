#! /usr/bin/env bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/config.sh
{
	# rclone --config=$RCLONE_CONFIG copy /var/lib/elasticsearch/ dochausersync:/dochauser_mount/elasticsearch/
	rclone --config=$RCLONE_CONFIG copy $ES_BACKUP_DIR dochausersync:/dochauser_mount/es_backup
} >> $LOG_FILE;
