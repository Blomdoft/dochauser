#!/bin/bash

# Elasticsearch server details
ES_HOST="192.168.2.8"
INDEX_NAME="dochauser"
ES_URL="http://$ES_HOST:9200/$INDEX_NAME/_search"

# Get the date 30 days ago in the format required by Elasticsearch
# DATE_30_DAYS_AGO=$(date -d '30 days ago' '+%Y%m%d%H%M%S')

CURRENT_YEAR=$(date +"%Y")
CURRENT_MONTH=$(date +"%m")
CURRENT_DAY=$(date +"%d")
CURRENT_HOUR=$(date +"%H")
CURRENT_MINUTE=$(date +"%M")
CURRENT_SECOND=$(date +"%S")

# Calculate the date 30 days ago
DATE_30_DAYS_AGO=$(date -u -v-30d +"%Y%m%dT%H%M%S.000Z" 2>/dev/null || date -u -d '30 days ago' +"%Y%m%dT%H%M%S.000Z" 2>/dev/null)

# Elasticsearch query
QUERY='{
  "query": {
    "range": {
      "timestamp": {
        "gte": "'$DATE_30_DAYS_AGO'"
      }
    }
  }
}'

# Send the query to Elasticsearch and parse the response
RESPONSE=$(curl -s -X GET "$ES_URL" -H 'Content-Type: application/json' -d "$QUERY")


# Parse each hit and process it
echo "$RESPONSE" | jq -c '.hits.hits[]' | while read -r line; do
  DIRECTORY=$(echo "$line" | jq -r '.["_source"]["directory"]')
  NAME=$(echo "$line" | jq -r '.["_source"]["name"]')
  TAGS=$(echo "$line" | jq -r '.["_source"]["tags"][]["tagname"]')
  
# Inside the loop that processes each document
FILENAME=$(echo "$line" | jq -r '.["_source"]["directory"]')
NAME=$(echo "$line" | jq -r '.["_source"]["name"]')

# Cut the filename at "archive" and use the part after it
ARCHIVE_PART=$(echo "$FILENAME" | awk -F'archive' '{print $2}')
NEW_FILENAME="${ARCHIVE_PART}/${NAME}"

# Check for tags and prepend the appropriate prefix
PREFIX=""
if [[ $TAGS == *"KH"* ]]; then
  PREFIX="KH"
elif [[ $TAGS == *"BS"* ]]; then
  PREFIX="BS"
fi

# Only proceed if a known tag is present
#if [[ -n $PREFIX ]]; then
  ORIGINAL_FILENAME="$NEW_FILENAME"
  GENERATED_FILENAME="${PREFIX}${NEW_FILENAME}"

  # Check if the file does not exist in the destination
  if [[ ! -f "$GENERATED_FILENAME" ]]; then
   echo cp "$ORIGINAL_FILENAME" "$GENERATED_FILENAME"
  fi
#fi


done
