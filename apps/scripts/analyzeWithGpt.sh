#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/config.sh
source $CURRENT_DIR/../config/apikey.sh

# Check if OPENAI_API_KEY is set
if [ -z "$OPENAI_API_KEY" ]; then
  echo "Info: OPENAI_API_KEY is not set."
  exit 1
fi

# Elasticsearch server details
INDEX_NAME="dochauser"
ES_URL="http://$ES_HOST:9200/$INDEX_NAME/_search"
UPDATE_URL="http://$ES_HOST:9200/$INDEX_NAME/_doc"
# Read the system role message from the file
SYSTEM_ROLE_MESSAGE=$(<$CURRENT_DIR/../config/prompt_message_dochausera.txt)

# OpenAI API details
API_ENDPOINT="https://api.openai.com/v1/chat/completions"
API_KEY="$OPENAI_API_KEY"
# Get the date 30 days ago in the format required by Elasticsearch
DATE_30_DAYS_AGO=$(date -u -v-200d +"%Y%m%dT%H%M%S.000Z" 2>/dev/null || date -u -d '30 days ago' +"%Y%m%dT%H%M%S.000Z" 2>/dev/null)

# Elasticsearch query to get the first document without analysis
QUERY='{
  "size": 300,
  "query": {
    "bool": {
      "must": {
        "range": {
          "timestamp": {
            "gte": "'$DATE_30_DAYS_AGO'"
          }
        }
      },
      "must_not": {
        "exists": {
          "field": "analysis"
        }
      }
    }
  }
}'
# Fetch documents from Elasticsearch
RESPONSE=$(curl -s -X GET "$ES_URL" -H 'Content-Type: application/json' -d "$QUERY")

echo "$RESPONSE"

echo "----"


# Process each document
echo "$RESPONSE" | jq -c '.hits.hits[]' | while read -r line; do
  ID=$(echo "$line" | jq -r '._id')
  TEXT=$(echo "$line" | jq -r '._source.text')

  # Interact with ChatGPT API to get analysis
  # Assuming the API returns JSON in the desired format

    # Prepare the data for the API request
    API_DATA=$(jq -n \
            --arg text "$TEXT" \
            --arg system_msg "$SYSTEM_ROLE_MESSAGE" \
            '{
                model: "gpt-4-1106-preview",
                messages: [
                {"role": "system", "content": $system_msg},
                {"role": "user", "content": $text}
                ],
                response_format: { "type": "json_object" }
            }')

    # Extract the analysis from the API response
    ANALYSIS=$(curl -s -X POST "$API_ENDPOINT" \
                -H "Content-Type: application/json" \
                -H "Authorization: Bearer $API_KEY" \
                -d "$API_DATA" | jq -r '.choices[0].message.content')

    echo "$ANALYSIS"

    # Update the document in Elasticsearch with the new analysis
    curl -s -X POST "$UPDATE_URL/$ID/_update" -H 'Content-Type: application/json' -d "{\"doc\": {\"analysis\": $ANALYSIS}}"

done
