#!/bin/bash
#TARGET=/Volumes/TRANSCEND16
#TARGET=/media/maria/TRANSCEND16
PREV_DIR="`pwd`"

if [ "@$MANAGE" = "@" ]; then
    MANAGE=true
fi

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
    #elif [ $code -eq 22 ]; then
    #    echo "  (ignore the Invalid argument error above since it is related to temporary files or other system files)"
    #    NOTE: Error 22 can be due to a missing path, so allow exit in that case.
    else
        xmessage -buttons Ok:0 -default Ok -nearmouse "$msg"
        exit $code
    fi
}

primaryvol="/media/maria/CRUZER64"
drive_description="CRUZER64 (Black and Red SanDisk Flash Drive)"
targetvol=
for tryvol in "/media/maria/CRUZER64" "/media/maria/FREEMCBOOT"
do
    if [ -d "$tryvol" ]; then
        targetvol="$tryvol"
        break
    fi
done

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
    xmessage -buttons Ok:0 -default Ok -nearmouse "Error: The drive was not detected. Try re-inserting $_description."
    # echo "$drive_name is not plugged in--cannot continue."
    #read -n 1 -p "Press [Enter] key to exit..."
    exit 1
fi

#TARGET=$targetvol/macbuntu
TARGET=$targetvol

DST_PROFILE="$TARGET/$USER"
mkdir -p "$DST_PROFILE"

# Below, home was formerly "Users" to match old mac backup drive:
mkdir -p "$DST_PROFILE/Documents"
mkdir -p "$DST_PROFILE/Desktop"
mkdir -p "$DST_PROFILE/Projects"
echo "* copying Desktop..."
src="$HOME/Desktop"
rsync --protect-args -tr --info=progress2 "$src/" "$DST_PROFILE/Desktop"
code=$?
if [ $code -ne 0 ]; then
    customExit "Copying $src failed. Look at the black Terminal window behind this message to see the errors and copy so that you can paste them into an email or document for support." $code
fi
#cp ~/Desktop/ $DST_PROFILE/Desktop
echo "* copying Projects..."
src="$HOME/Projects"
rsync --protect-args -tr --info=progress2 "$src/" "$DST_PROFILE/Projects"
code=$?
if [ $code -ne 0 ]; then
    customExit "Copying $src failed. Look at the black console window to see the errors and copy so that you can paste them into an email or document for support." $code
fi
#cp -Rvf ~/Projects/ $DST_PROFILE/Projects


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
        rsync --protect-args -tr --info=progress2 "$this_source_path/" "$this_dest_path"
        #^ formerly had no slash
        code=$?
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
rsync --protect-args -tr --info=progress2 --exclude-from='/home/maria/exclude.txt' "$src/" "$DST_PROFILE/Documents"
code=$?
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
xmessage -buttons Ok:0 -default Ok -nearmouse "The backup completed successfully."
exit 0
