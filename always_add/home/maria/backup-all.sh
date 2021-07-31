#!/bin/bash

# This file is for root.
# For maria, see /home/maria/Projects/BackupNow/BackupNow.sh

# See https://ostechnix.com/backup-entire-linux-system-using-rsync/
TARGET="/media/maria/765f18ec-e76a-4c35-bf7c-31ac9592e426/m"
sudo rsync -aAXv / --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} $TARGET
