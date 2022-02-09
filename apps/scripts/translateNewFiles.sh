#! /usr/bin/env bash

BASE=/scanner
#BASE=/Users/florian/Downloads/media/stick

MONITOR_DIR=$BASE/scanner/
ARCHIVE_DIR=$BASE/archive/
LOG_FILE=$BASE/apps/log/ocrmypdf.log

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

          # Strip all double whitespaces and linefeeds from text
          PDFTXT=$(tr -ds  "\n\f" " " < "$OUTPUT_DIR${entry##*/}.txt")
          NAME=${entry##*/}

          # Assemble the thumbnail subjason
          SEARCH="$OUTPUT_DIR${entry##*/}"
          for JPGFILE in $SEARCH*.jpg; do
            THUMBNAILS="$THUMBNAILS{\"imgname\" : \"${JPGFILE##*/}\",\"imdirectory\" : \"/$OUTPUT_DIR\"},"
          done

          ## strip the last ","
          THUMBNAILS=${THUMBNAILS::${#THUMBNAILS}-1}

          JSON="{
                    \"document\" : {
                      \"name\" : \"$NAME\",
                      \"directoy\" : \"$OUTPUT_DIR\",
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
                    }
                  }"
          echo "$JSON" > "$OUTPUT_DIR${entry##*/}.json"

          ### Mark as processed
          touch "$entry.1"


          ## enough voodoo
      fi
    done

} >> LOG_FILE;
