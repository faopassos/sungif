#!/bin/bash

BASE_DIR="."
DEST_DIR="$BASE_DIR/images"
LOG_FILE=$(date +"$BASE_DIR/log/%F_get-images.log")

exec >> $LOG_FILE 2>&1

SERVER="https://sdo.gsfc.nasa.gov/assets/img/swpc"
FILTER="0171"

DAY_MATCH=$(date +%Y%m%d -d "-1 days")
#[ -d "$DEST_DIR/$DAY_MATCH/" ] || mkdir -p $DEST_DIR/$DAY_MATCH/

LIST=$(curl -k -s $SERVER/$FILTER/ | grep "$DAY_MATCH" | awk -F '"' '{print $6}')

for img in $LIST; do 
	#wget -O $DEST_DIR/$DAY_MATCH/$img $SERVER/$FILTER/$img
	wget --no-check-certificate -O $DEST_DIR/$img $SERVER/$FILTER/$img
done
