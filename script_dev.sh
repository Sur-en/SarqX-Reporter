#!/usr/bin/env bash

# TODO: check that log file starts from [NEW] status

LOG_DIR=$1

WHO_AM_I=$(whoami)

if [[ $WHO_AM_I == "root" ]]; then
  for i in {1..1000000}
  do
    STAT=$(dmidecode -t processor)
    SHA1=$(echo -n "$STAT" | sha1sum | cut -d " " -f1)

    FILE_PATH="$LOG_DIR/$SHA1.srq"
    echo $FILE_PATH

    if [ -f "$FILE_PATH" ]; then
      # When file exists just log that everything is ok
      LOG_DATE=$(date +"[%Y-%m-%d %T]")
      OK_STATUS="[OK]"

      echo -e "$LOG_DATE $OK_STATUS" >> $FILE_PATH
    else
      LOG_DATE=$(date +"[%Y-%m-%d %T]")
      NEW_STATUS="[NEW]"

      touch "$FILE_PATH"
      echo -e "$LOG_DATE $NEW_STATUS:\n$STAT\n" > $FILE_PATH
      chmod a=rw "$FILE_PATH"
    fi

    sleep 1s
  done

  exit 0
fi
