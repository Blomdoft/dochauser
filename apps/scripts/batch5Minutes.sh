#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/../config/config.sh

$CURRENT_DIR/analyzeWithGpt.sh
sleep(10) # Wait a bit so elastic search serves the new data.
$CURRENT_DIR/copyToStructureAnalyzed.sh
$CURRENT_DIR/syncCloud.sh
