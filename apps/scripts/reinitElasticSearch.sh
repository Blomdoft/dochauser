
#! /usr/bin/env bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/config.sh

{
    cur_files=$(find $ARCHIVE_DIR -name "*.pdf.json")


    for entry in $cur_files
    do
        UUID_LINE=$(grep "\"id\" : \"" $entry | tr -d '":, ')
        UUID=${UUID_LINE:3:35}
        #send the record to elastic search
        curl -H "Content-Type: application/json" -XPOST "http://localhost:9200/dochauser/document/$UUID" -d @$entry

    done

} 
