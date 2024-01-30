#! /usr/bin/env bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/../config/config.sh
{
	rclone --config=$RCLONE_CONFIG copy /home/scanner/archive/ dochausersync:/dochauser_mount/archive/
} >> $LOG_FILE;
