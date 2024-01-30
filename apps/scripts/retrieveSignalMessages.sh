#! /usr/bin/env bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/../config/config.sh

{
  call=$($SIGNAL_DIR/signal-cli -a $SIGNAL_NUMBER receive)
  echo "$call"
} >> $LOG_FILE;
