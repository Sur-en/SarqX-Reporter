#!/usr/bin/env bash

# LOG_DIR="/var/opt/sarqx-reporter/logs"
LOG_DIR="$HOME/test"

if sudo true; then
  for i in {1..1000000}
  do
    STAT=$(sudo dmidecode -t processor)
    SHA1=$(echo -n "$STAT" | sha1sum | cut -d " " -f1)

    FILE_PATH="$LOG_DIR/$SHA1.srq"
    echo $FILE_PATH

    if [ -f "$FILE_PATH" ]; then
      # When file exists just log that everything is ok
      LOG_DATE=$(date +"[%Y-%m-%d %T]")
      OK_STATUS="[OK]"

      sudo echo -e "$LOG_DATE $OK_STATUS" >> $FILE_PATH
    else
      LOG_DATE=$(date +"[%Y-%m-%d %T]")
      OK_STATUS="[NEW]"

      sudo touch "$FILE_PATH"
      sudo echo -e "$LOG_DATE $OK_STATUS:\n$STAT\n" > $FILE_PATH
    fi

    sleep 1s
  done

  exit 0
else
  exit 1
fi

exit 0
