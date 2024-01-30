#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/../config/config.sh

$CURRENT_DIR/analyzeWithGpt.sh
$CURRENT_DIR/copyToStructureAnalyzed.sh
$CURRENT_DIR/syncCloud.sh
