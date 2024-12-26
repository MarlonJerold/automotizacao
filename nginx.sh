#!/bin/bash

DIR="/home/marlon/nginx_logs"
mkdir -p "$DIR"

SERVICE="nginx"
DATETIME=$(date "+%Y-%m-%d %H:%M:%S")

if systemctl is-active --quiet $SERVICE; then
    STATUS="ONLINE"
    MESSAGE="O serviço $SERVICE está ONLINE."
    FILE="$DIR/status_online.log"
else
    STATUS="OFFLINE"
    MESSAGE="O serviço $SERVICE está OFFLINE."
    FILE="$DIR/status_offline.log"
fi

echo "$DATETIME - $SERVICE - $STATUS - $MESSAGE" >> $FILE
