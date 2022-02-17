#! /usr/bin/env bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/config.sh

{
    cur_files=$(ls  ${MONITOR_DIR}*.pdf)

    for entry in $cur_files
    do

      if [ -f "$entry.1" ]; then
        echo ""
      else
          echo "${date} Needs to be processed: $entry"

          ### Prepare output folder, which is year/month/day ###

          YEAR=$(date -r "$entry" +%Y)
          MONTH=$(date -r "$entry" +%m)
          DAY=$(date -r "$entry" +%d)
          HOUR=$(date -r "$entry" +%H)
          MINUTE=$(date -r "$entry" +%M)
          OUTPUT_DIR="$ARCHIVE_DIR$YEAR/$MONTH/$DAY/";

          if [ ! -d "$OUTPUT_DIR" ]; then
            mkdir -p "$OUTPUT_DIR"
            echo "${date} Created new output directory $OUTPUT_DIR"
          fi


          ### Process the file ###

          # OCR the document
          ocrmypdf -l deu "$entry" "$OUTPUT_DIR${entry##*/}"
          # extract all text of the pdf to a text file
          pdf2txt -o "$OUTPUT_DIR${entry##*/}.txt" "$OUTPUT_DIR${entry##*/}"
          # save thumbnails of the pages of the pdf
          convert "$entry" -quality 30 "$OUTPUT_DIR${entry##*/}.jpg"


          ### Produce initial JSON document ###

	        UUID=$(uuid)

          # Strip all double whitespaces and linefeeds from text
          PDFTXT=$(tr -cs  "[:alnum:]" " " < "$OUTPUT_DIR${entry##*/}.txt")
          NAME=${entry##*/}

          # Assemble the thumbnail subjason
          SEARCH="$OUTPUT_DIR${entry##*/}"


	  THUMBNAILS=""
	  SIGNALSENDTHUMBS=""
          for JPGFILE in $SEARCH*.jpg; do
            THUMBNAILS="$THUMBNAILS{\"imgname\" : \"${JPGFILE##*/}\",\"imgdirectory\" : \"/$OUTPUT_DIR\"},"
            SIGNALSENDTHUMBS="$SIGNALSENDTHUMBS$OUTPUT_DIR${JPGFILE##*/} "
          done

          ## strip the last ","
          THUMBNAILS=${THUMBNAILS::${#THUMBNAILS}-1}

          JSON="{
                      \"id\" : \"$UUID\",
		      \"name\" : \"$NAME\",
                      \"directory\" : \"$OUTPUT_DIR\",
                      \"text\" : \"$PDFTXT\",
                      \"timestamp\" : \"$YEAR-$MONTH-$DAY-$HOUR-$MINUTE\",
                      \"origin\" : \"SCAN\",
                      \"thumbnails\" : [
                        $THUMBNAILS
                      ],
                      \"tags\" : [
                        {
                          \"tagname\" : \"SCANNED\"
                        }
                      ]
                  }"
          echo "$JSON" > "$OUTPUT_DIR${entry##*/}.json"


      	  ## send the record to elastic search
          curl -H "Content-Type: application/json" -XPOST "http://localhost:9200/dochauser/document/$UUID" -d @$OUTPUT_DIR${entry##*/}.json

          ## send a notification to signal group
          $SIGNAL_DIR/signal-cli -a $SIGNAL_NUMBER send -m $NAME -g $SIGNAL_GROUP -a $SIGNALSENDTHUMBS

          ### Mark as processed
          touch "$entry.1"


          ## enough voodoo
      fi
    done

} >> $LOG_FILE;
