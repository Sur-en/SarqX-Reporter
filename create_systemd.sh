#!/usr/bin/env bash

ARG="$1"

function find_path_to_launcher() {
  if [[ $(whoami) == "root" ]] && [[ $ARG == "prod" ]]; then
    local path='/opt/sarqx-reporter/bin/sarqx-reporter'
    echo "$path"
  elif [[ $(whoami) == "root" ]] && [[ $ARG == "dev" ]]; then
    local path="$(pwd)/sarqx-reporter"
    echo "$path"
  else
    local path="$(pwd)/sarqx-reporter"
    echo "$path"
  fi
}

function find_path_to_logs_dir() {
  if [[ $(whoami) == "root" ]] && [[ $ARG == "prod" ]]; then
    local path='/var/opt/sarqx-reporter/logs'
    echo "$path"
  elif [[ $(whoami) == "root" ]] && [[ $ARG == "dev" ]]; then
    local path="$(pwd)/logs"
    echo "$path"
  else
    local path="$(pwd)/logs"
    echo "$path"
  fi
}

function make_daemon_file_name() {
  if [[ $(whoami) == "root" ]] && [[ $ARG == "prod" ]]; then
    local name="sarqxd.service"
    echo "$name"
  elif [[ $(whoami) == "root" ]] && [[ $ARG == "dev" ]]; then
    local name="sarqxd-dev.service"
    echo "$name"
  else
    local name="sarqxd-dev.service"
    echo "$name"
  fi
}

PATH_TO_LAUNCHER=$(find_path_to_launcher)
PATH_TO_LOGS=$(find_path_to_logs_dir)
FILE_NAME=$(make_daemon_file_name)

# TODO: send path to log directory via ExecStart
CONTENT="[Unit]
Description = SarqX CLI daemon
After = network.target
Wants = network-online.target

[Service]
Type = simple
User = root
ExecStart = $PATH_TO_LAUNCHER --run $PATH_TO_LOGS
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
