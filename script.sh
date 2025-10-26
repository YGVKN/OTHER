#!/bin/sh
#set -eExuo pipefail
set -eEuo pipefail # With X flag - Show step script info
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/tmp/out.log 2>&1

if [[ -d /tmp/app && -f /tmp/app/log.txt ]]; then
    echo "Directory & file exists ... !"   # Show info to /tmp/out.log
    openssl rand -hex 20 >> /tmp/app/log.txt
else
    mkdir -p /tmp/app/ && openssl rand -hex 20 >> /tmp/app/log.txt
fi

# Just deamon script  nohup watch -n19 ./script.sh  2>&1 <<& - & disown
