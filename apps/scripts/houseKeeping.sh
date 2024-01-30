#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/../config/config.sh

{
    INDEX_NAME="dochauser"

    echo "Starting cleanup process..."

    # Iterate over each PDF file in the scanned directory older than 30 days
    find "$MONITOR_DIR" -name "*.pdf" -mtime +30 | while read pdf_file; do
        pdf_1_file="${pdf_file}.1"

        # Check for .1 file
        if [ -f "$pdf_1_file" ]; then
            filename=$(basename "$pdf_file")

            echo "Processing file: $filename"

            # Check if filename is in Elasticsearch index
            if curl -s -X GET "http://${ES_HOST}:9200/${INDEX_NAME}/_search?q=filename:${filename}" | grep -q "\"hits\":{\"total\":{\"value\":1"; then
                
                # Check if file exists in the archive directory tree
                if find "$ARCHIVE_DIR" -name "$filename" | grep -q .; then
                    echo "Deleting files: $pdf_file and $pdf_1_file"
                    rm "$pdf_file"
                    rm "$pdf_1_file"
                else
                    echo "File not found in archive: $filename"
                fi
            else
                echo "File not found in Elasticsearch index: $filename"
            fi
        else
            echo "No .1 file for: $pdf_file"
        fi
    done

    echo "Cleanup process completed."
} >> $LOG_FILE