#!/usr/bin/env bash

function find_path_to_script() {
  if [[ $(whoami) == "root" ]]; then
    local path='/opt/sarqx-reporter/bin/script.sh'
    echo "$path"
  else
    local path="$(pwd)/sarqx-reporter --run"
    echo "$path"
  fi
}

function make_daemon_file_name() {
  if [[ $(whoami) == "root" ]]; then
    local name="sarqxd.service"
    echo "$name"
  else
    local name="sarqxd-dev.service"
    echo "$name"
  fi
}

PATH_TO_SCRIPT=$(find_path_to_script)
FILE_NAME=$(make_daemon_file_name)

# TODO: send path to log directory via ExecStart
CONTENT="[Unit]
Description = SarqX CLI daemon
After = network.target
Wants = network-online.target

[Service]
Type = simple
User = root
ExecStart = $PATH_TO_SCRIPT
Restart = on-abort
StartLimitInterval = 60
StartLimitBurst = 10

[Install]
WantedBy = multi-user.target"

if [ -f "$FILE_NAME=" ]; then
  echo -e "$CONTENT" > "$FILE_NAME"
else
  touch "$FILE_NAME"
  echo -e "$CONTENT" > "$FILE_NAME"
fi

echo "$FILE_NAME"
