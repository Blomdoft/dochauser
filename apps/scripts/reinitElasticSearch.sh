#! /usr/bin/env bash

source config.sh

{
    cur_files=$(find $ARCHIVE_DIR -name "*.pdf.json")

    for entry in $cur_files
    do

          UUID_LINE=$(grep "\"id\" : \"" $ARCHIVE_DIR$entry)
          UUID=$($UUID_LINE:31:36)
          ## send the record to elastic search
          curl -H "Content-Type: application/json" -XPOST "http://localhost:9200/dochauser/document/$UUID" -d @$ARCHIVE_DIR$entry

    done

} >> $LOG_FILE;
