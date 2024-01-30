#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/../config/config.sh

./analyzeWithGpt.sh
./copyToStructureAnalyzed.sh
./syncCloud.sh
