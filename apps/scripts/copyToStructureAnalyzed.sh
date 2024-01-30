#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/config.sh

# Elasticsearch server details
INDEX_NAME="dochauser"
ES_URL="http://$ES_HOST:9200/$INDEX_NAME/_search"

mkdir -p "$CATEGORIZED_DIR"

# Get the date 30 days ago in the format required by Elasticsearch
DATE_30_DAYS_AGO=$(date -u -v-30d +"%Y%m%dT%H%M%S.000Z" 2>/dev/null || date -u -d '30 days ago' +"%Y%m%dT%H%M%S.000Z" 2>/dev/null)

# Elasticsearch query to get documents with analysis
QUERY='{
  "size": 1000,
  "query": {
    "bool": {
      "must": {
        "range": {
          "timestamp": {
            "gte": "'$DATE_30_DAYS_AGO'"
          }
        }
      },
      "filter": {
        "exists": {
          "field": "analysis.filename"
        }
      }
    }
  }
}'

# Fetch documents from Elasticsearch
RESPONSE=$(curl -s -X GET "$ES_URL" -H 'Content-Type: application/json' -d "$QUERY")

echo $RESPONSE

# Process each document
echo "$RESPONSE" | jq -c '.hits.hits[]' | while read -r line; do
  DIRECTORY=$(echo "$line" | jq -r '._source.directory')
  FILENAME=$(echo "$line" | jq -r '._source.name')
  FILENAMEDEST=$(echo "$line" | jq -r '._source.analysis.filename')
  CATEGORY_LEVEL1=$(echo "$line" | jq -r '._source.analysis.category_level1')
  CATEGORY_LEVEL2=$(echo "$line" | jq -r '._source.analysis.category_level2')
  DOCUMENT_DATE=$(echo "$line" | jq -r '._source.timestamp' | cut -c 3-8)

  # Extract the part of the directory after "/archive/"


  MODIFIED_DIRECTORY=$(echo "$DIRECTORY" | awk -F'/archive/' '{print $2}')
  echo $MODIFIED_DIRECTORY

  # Prepend your base directory
  SOURCE_PATH="${ARCHIVE_DIR}${MODIFIED_DIRECTORY}${FILENAME}"

  # Generate the destination path
  DEST_PATH="${CATEGORIZED_DIR}/${CATEGORY_LEVEL1}/${CATEGORY_LEVEL2}/${DOCUMENT_DATE}_${FILENAMEDEST}"

    echo $SOURCE_PATH
    echo $DEST_PATH

  # Create the destination directory tree if it doesn't exist

  if [ ! -f "$DEST_PATH" ]; then
    mkdir -p "$(dirname "$DEST_PATH")"
    ln -s "${SOURCE_PATH}" "${DEST_PATH}"
  fi

done
