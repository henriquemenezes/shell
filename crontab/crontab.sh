#!/bin/bash

# Default values
OPT_M=1
CRONTAB_LINE=

header() {
  echo "    ___                _        _      "
  echo "   / __\ __ ___  _ __ | |_ __ _| |__   "
  echo "  / / | '__/ _ \| '_ \| __/ _\` | '_ \ "
  echo " / /__| | | (_) | | | | || (_| | |_) | "
  echo " \____/_|  \___/|_| |_|\__\__,_|_.__/  "
  echo
}

header

usage() {
  cat <<EOF
    Usage: $0 [OPTION] COMMAND
       or: $0 [OPTION] SCRIPT

    Script to setup user cron tasks in minutes.
    
        Each user can have their own crontab, 
        and though these are files in 
          /var/spool/cron/crontabs

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

# COMMAND or SCRIPT
RUN=$*

echo "Crontab will run: $RUN"

if ! [[ $OPT_M =~ ^[0-9]+$ ]]; then
  echo "    error: minutes must be integer greater than or equal to 1."
  echo
  usage
  exit 1
elif [ $OPT_M -eq 1 ]; then
  echo "Configuring task to run each 1 minute."
  CRONTAB_LINE="* * * * * $RUN"
elif [ $OPT_M -ge 1 ]; then
  echo "Configuring task to run each $OPT_M minutes."
  CRONTAB_LINE="*/$OPT_M * * * * $RUN"
fi

if $(crontab -l &> /dev/null) ; then
  echo "Updating crontab user file!"
  crontab -l > /tmp/crontab_$USER
  echo "$CRONTAB_LINE" >> /tmp/crontab_$USER
  crontab /tmp/crontab_$USER
else
  echo "Creating a new crontab file!"
  echo "$CRONTAB_LINE" > /tmp/crontab_$USER
  crontab /tmp/crontab_$USER
fi

exit 0
