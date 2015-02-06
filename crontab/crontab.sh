#!/bin/bash

# Default values
OPT_M=1

header() {
  echo "    ___                _        _      "
  echo "   / __\ __ ___  _ __ | |_ __ _| |__   "
  echo "  / / | '__/ _ \| '_ \| __/ _\` | '_ \ "
  echo " / /__| | | (_) | | | | || (_| | |_) | "
  echo " \____/_|  \___/|_| |_|\__\__,_|_.__/  "
  echo
}

usage() {
  cat <<EOF
    Usage: $0 [OPTION] COMMAND
       or: $0 [OPTION] SCRIPT

    Script to setup cron tasks in minutes.

    OPTIONS:
      -h    Show help message
      -m N  Runs every N minutes the command/script. (Default: 1 minute)
EOF
}

# Check if number of arguments is equal to 0
if [ $# -eq 0 ]; then
  usage
  exit 0
fi

while getopts ":m::h" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    m)
      OPT_M=$OPTARG
      ;;
    \?)
      usage
      exit 1
      ;;
    :)
      usage
      exit 1
      ;;
  esac
done

shift $(($OPTIND - 1))

if [ $# -eq 0 ]; then
  echo "    error: missing COMMAND or SCRIPT."
  echo
  usage
  exit 1
fi

FILE=$1

echo $FILE

exit 0
