#! /usr/bin/env bash

source config.sh

{
  call=$($BASE_DIR/$SIGNAL_VERSION/bin/signal-cli -a $SIGNAL_NUMBER receive)
  echo "$call"
} >> $LOG_FILE;
