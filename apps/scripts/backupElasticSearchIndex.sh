#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/config.sh

{
    INDEX_NAME="dochauser"
    BACKUP_DIR=${ES_BACKUP_DIR}
    SCROLL_TIME="1m"
    CURRENT_DATE=$(date +"%Y%m%d")
    BACKUP_FILE="${BACKUP_DIR}/${CURRENT_DATE}_${INDEX_NAME}.json"

    mkdir -p "$(dirname "$BACKUP_FILE")"

    # Initialize scroll
    INITIAL_RESPONSE=$(curl -s -X GET "http://${ES_HOST}:9200/${INDEX_NAME}/_search?scroll=${SCROLL_TIME}" -H 'Content-Type: application/json' -d '{"query": {"match_all": {}}}')
    SCROLL_ID=$(echo $INITIAL_RESPONSE | jq -r '._scroll_id')

    # Write the initial batch of documents to file
    echo $INITIAL_RESPONSE | jq '.hits.hits' > "$BACKUP_FILE"

    # Continue scrolling until all documents are fetched
    while true; do
        RESPONSE=$(curl -s -X GET "http://${ES_HOST}:9200/_search/scroll" -H 'Content-Type: application/json' -d "{\"scroll\": \"${SCROLL_TIME}\", \"scroll_id\": \"$SCROLL_ID\"}")
        SCROLL_ID=$(echo $RESPONSE | jq -r '._scroll_id')
        HITS=$(echo $RESPONSE | jq '.hits.hits')

        if [ "$HITS" == "[]" ]; then
            break
        fi

        echo $HITS >> "$BACKUP_FILE"
    done

    # Optional: Clear the scroll
    curl -X DELETE "http://${ES_HOST}:9200/_search/scroll" -H 'Content-Type: application/json' -d "{\"scroll_id\": \"$SCROLL_ID\"}"

    # sync with rclone to cloud
    rclone --config=$RCLONE_CONFIG copy $ES_BACKUP_DIR dochausersync:/dochauser_mount/es_backup

} >> LOG_FILE