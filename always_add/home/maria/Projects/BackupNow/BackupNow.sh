#!/bin/bash
#TARGET=/Volumes/TRANSCEND16
#TARGET=/media/maria/TRANSCEND16
PREV_DIR="`pwd`"
PARTIAL_LOG=~/Desktop/backup-partial.log
if [ -f "$PARTIAL_LOG" ]; then
    rm "$PARTIAL_LOG"
fi
if [ "@$MANAGE" = "@" ]; then
    MANAGE=true
fi

mkdir -p ~/tmp
ERROR_TMP=~/tmp/BackupNow-last-error.txt

for var in "$@"
do
    if [ "@$var" = "@--no-management" ]; then
        MANAGE=false
    fi
done


if [ "@$MANAGE" = "@true" ]; then
    cd ~/git/BackupNow
    if [ $? -eq 0 ]; then
        echo "* updating BackupNow..."
        git pull
        ~/git/BackupNow/manage.sh
        if [ $? -eq 0 ]; then
            echo "  * The backup was skipped since the system management script ran a different backup."
            exit 0
        else
            echo "  * The shell backup will run since the updated didn't run a backup."
        fi
    else
        echo "  * The shell backup will run since there was no updated backup program."
    fi
fi
DATE_FILE=
# ^ set later
cd "$PREV_DIR"

customExit(){
    msg="$1"
    code=""
    if [ ! -d "$2" ]; then
        code=$2
    fi
    code=$2
    if [ -z "$1" ]; then
        msg="Unknown Error $code"
    elif [ ! -z "$code" ]; then
        msg="Error code $code: $msg"
    fi
    if [ $code -eq 23 ]; then
        echo "  (ignore the Invalid argument error above since it is related to temporary files or other system files)"
    elif [ $code -eq 20 ]; then
        msg="Code 20: The user canceled the operation with Ctrl+C."
        xmessage -buttons Ok:0 -default Ok -nearmouse "$msg"
    else
        xmessage -buttons Ok:0 -default Ok -nearmouse "$msg"
        if [ ! -z "$DATE_FILE" ]; then
            echo "$msg" >> "$DATE_FILE"
        fi
        cp "$DATE_FILE" "$PARTIAL_LOG"
        chmod -x "$PARTIAL_LOG"
        echo "\n\n(This is a copy of $DATE_FILE)" >> "$PARTIAL_LOG"
        exit $code
    fi
    if [ ! -z "$DATE_FILE" ]; then
        echo "$msg" >> "$DATE_FILE"
    fi

    #elif [ $code -eq 22 ]; then
    #    echo "  (ignore the Invalid argument error above since it is related to temporary files or other system files)"
    #    NOTE: Error 22 can be due to a missing path, so allow exit in that case.
}

primaryvol="/media/maria/CRUZER64"
drive_description="CRUZER64 (Black and Red SanDisk Flash Drive)"
targetvol=
targetvol_name=

#try_vol_name="`basename "$primaryvol"`"
#cd ~/git/BackupNow
#if [ -f "backupnow/__init__.py" ]; then
#    python3 backupnow/mount.py $try_vol_name
#else
#    xmessage -buttons Ok:0 -default Ok -nearmouse "$0 must run from the BackupNow repo to attempt to mount the drive automatically." $code
#fi
#cd "$PREV_DIR"

cd ~/git/BackupNow
if [ ! -f "backupnow/__init__.py" ]; then
    xmessage -buttons Ok:0 -default Ok -nearmouse "$0 must run from the BackupNow repo to attempt to mount the drive automatically." $code
fi

for tryvol in "/media/maria/BACKUP" "/media/maria/CRUZER641" "/media/maria/CRUZER64" "/media/maria/FREEMCBOOT"
do
    try_vol_name="`basename "$tryvol"`"
    if [ -f "backupnow/mount.py" ]; then
        echo "* attempting to mount $try_vol_name..."
        python3 backupnow/mount.py $try_vol_name
        if [ $? -eq 0 ]; then
            echo "  - OK (mounted $try_vol_name)"
        fi
    else
        echo "* Warning: backupnow/mount.py doesn't exist in \"`pwd`\"."
    fi
    if [ -d "$tryvol" ]; then
        targetvol="$tryvol"
        targetvol_name="$try_vol_name"
        break
    fi
done
cd "$PREV_DIR"

if [ -z "$targetvol" ]; then
    #( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.25s ; kill -9 $pid
    #( speaker-test -t sine -f 700 )& pid=$! ; sleep 0.25s ; kill -9 $pid
    echo ""
    echo ""
    _description="$primaryvol"
    # ^ Use $primaryvol since no $targetvol was found.
    if [ ! -z "$drive_description" ]; then
        _description="$drive_description"
    fi
    msg="Error: The drive was not detected. Try re-inserting $_description."
    xmessage -buttons Ok:0 -default Ok -nearmouse "$msg"
    # echo "$drive_name is not plugged in--cannot continue."
    #read -n 1 -p "Press [Enter] key to exit..."
    customExit "$msg"
fi

#TARGET=$targetvol/macbuntu
TARGET=$targetvol
echo "* Using volume: '$TARGET'"

DST_PROFILE="$TARGET/$USER"
mkdir -p "$DST_PROFILE"
echo "* Using profile destination: '$DST_PROFILE'"

# Below, home was formerly "Users" to match old mac backup drive:
mkdir -p "$DST_PROFILE/Documents"
mkdir -p "$DST_PROFILE/Desktop"
mkdir -p "$DST_PROFILE/Projects"
echo "* testing drive..."
DATE="`date '+%Y-%m-%d %H:%M:%S'`"
DATE_FILE="$TARGET/backup.log"
if [ -f "$DATE_FILE" ]; then
    rm -f "$DATE_FILE"
    if [ $? -ne 0 ]; then
        customExit "Error: $TARGET is readonly. 'rm -f $DATE_FILE' failed."
        
    fi
fi
echo "started=\"$DATE\"" > "$DATE_FILE"

if [ -f "$DATE_FILE" ]; then
    echo "  - OK (wrote $DATE_FILE)"
else
    customExit "   - FAILED (could not create $DATE_FILE)"
    
fi
echo "* copying Desktop..."
src="$HOME/Desktop"
echo "rsync --protect-args -tr --info=progress2 \"$src/\" \"$DST_PROFILE/Desktop\""
rsync --protect-args -tr --info=progress2 "$src/" "$DST_PROFILE/Desktop" 2> "$ERROR_TMP"
code=$?
cat $ERROR_TMP | tee -a "$DATE_FILE"
rm $ERROR_TMP
if [ $code -ne 0 ]; then
    customExit "Copying $src failed. Look at the black Terminal window behind this message to see the errors and copy so that you can paste them into an email or document for support." $code
fi
#cp ~/Desktop/ $DST_PROFILE/Desktop
echo "* copying Projects..."
src="$HOME/Projects"
echo "rsync --protect-args -tr --info=progress2 \"$src/\" \"$DST_PROFILE/Projects\""
rsync --protect-args -tr --info=progress2 "$src/" "$DST_PROFILE/Projects" 2> "$ERROR_TMP"
code=$?
cat $ERROR_TMP | tee -a "$DATE_FILE"
rm $ERROR_TMP
if [ $code -ne 0 ]; then
    customExit "Copying $src failed. Look at the black console window to see the errors and copy so that you can paste them into an email or document for support." $code
fi
# cp -Rvf ~/Projects/ $DST_PROFILE/Projects

echo "* copying Firefox Bookmarks..."
#formerly fdp08zhg:
#this_source_path="/home/maria/.mozilla/firefox/8bvxllvz.default/bookmarkbackups"
#this_dest_path="$DST_PROFILE/.mozilla/firefox/8bvxllvz.default/bookmarkbackups"
for sub in `ls ~/.mozilla/firefox`
do
    this_source_path="/home/maria/.mozilla/firefox/$sub/bookmarkbackups"
    this_dest_path="$DST_PROFILE/.mozilla/firefox/$sub/bookmarkbackups"
    if [ -d "$this_source_path" ]; then
        mkdir -p "$this_dest_path"
        rsync --protect-args -tr --info=progress2 "$this_source_path/" "$this_dest_path" 2> "$ERROR_TMP"
        code=$?
        cat $ERROR_TMP | tee -a "$DATE_FILE"
        rm $ERROR_TMP
        #^ formerly had no slash
        if [ $code -ne 0 ]; then
            customExit "Copying $src failed with code $code. Look at the black Terminal window behind this message to see the errors and copy and paste them to somewhere." $code
        fi
    else
        if [ -d "$this_dest_path" ]; then
            rmdir "$this_dest_path"
        fi
    fi
done

echo "* copying Documents..."
src="$HOME/Documents"
echo "rsync --protect-args -tr --info=progress2 --exclude-from='/home/maria/exclude.txt' \"$src/\" \"$DST_PROFILE/Documents\""
rsync --protect-args -tr --info=progress2 --exclude-from='/home/maria/exclude.txt' "$src/" "$DST_PROFILE/Documents" 2> "$ERROR_TMP"
code=$?
cat $ERROR_TMP | tee -a "$DATE_FILE"
rm $ERROR_TMP
if [ $code -ne 0 ]; then
    customExit "Copying $src failed. Look at the black console window to see the errors and copy and paste them to somewhere." $code
fi
#cp -Rvf "$HOME/Documents/" "$DST_PROFILE/Documents"
#if [ $? -ne 0 ]; then
#    xmessage -buttons Ok:0 -default Ok -nearmouse "Error: backup $DST_PROFILE/Documents failed. Try re-inserting $targetvol."
#    ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.25s ; kill -9 $pid
#    ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.25s ; kill -9 $pid
#    ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.25s ; kill -9 $pid
#    exit 1
#fi

SECONDARY=/media/maria/NOT_ON_COMPUTER
if [ -f $SECONDARY/volume.rc ]; then
    echo "* Backing up NOT_ON_COMPUTER"
    rsync -rt --info=progress2 $SECONDARY/ $TARGET/backup_of_not_on_computer 2> "$ERROR_TMP"
    code2=$?
    cat $ERROR_TMP | tee -a "$DATE_FILE"
    rm $ERROR_TMP
    if [ $code2 -ne 0 ]; then
        customExit "Copying $src failed. Look at the black console window to see the errors and copy and paste them to somewhere." $code2
    fi
fi
END_DATE="`date '+%Y-%m-%d %H:%M:%S'`"
echo "finished=\"$END_DATE\"" >> "$DATE_FILE"
# Last successful backup:
DONE_LOG=~/Desktop/backup-complete.log
cp "$DATE_FILE" "$DONE_LOG"
chmod -x "$DONE_LOG"
echo "This is the log of the last successful backup. For any later backups attempted with errors see the backup.log file on the BACKUP drive instead." >> "$DONE_LOG"
xmessage -buttons Ok:0 -default Ok -nearmouse "The backup completed successfully."
exit 0
