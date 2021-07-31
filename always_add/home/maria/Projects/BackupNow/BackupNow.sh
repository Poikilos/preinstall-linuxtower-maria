#!/bin/sh
#TARGET=/Volumes/TRANSCEND16
#TARGET=/media/maria/TRANSCEND16

cd ~/git/BackupNow
if [ $? -eq 0 ]; then
    git pull
    ~/git/BackupNow/manage.sh
    if [ $? -eq 0 ]; then
        echo "The backup was skipped since BackupNow for Python ran."
        exit 0
    fi
fi

customExit(){
    msg="$1"
    code="$2"
    if [ -z "$1" ]; then
        msg="Unknown Error $2"
    fi
    xmessage -buttons Ok:0 -default Ok -nearmouse "$msg"
    exit $code
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
  exit
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
rsync -tr --info=progress2 "$HOME/Desktop/" "$DST_PROFILE/Desktop"
#cp ~/Desktop/ $DST_PROFILE/Desktop
echo "* copying Projects..."
rsync -tr --info=progress2 "$HOME/Projects/" "$DST_PROFILE/Projects"
#cp -Rvf ~/Projects/ $DST_PROFILE/Projects
echo "* copying Firefox Bookmarks..."
#formerly fdp08zhg:
this_source_path="/home/maria/.mozilla/firefox/8bvxllvz.default/bookmarkbackups"
this_dest_path="$DST_PROFILE/.mozilla/firefox/8bvxllvz.default/bookmarkbackups"
mkdir -p "$this_dest_path"
rsync -tr --info=progress2 "$this_source_path/" "$this_dest_path"
#^ formerly had no slash
echo "* copying Documents..."
rsync -tr --info=progress2 --exclude-from='/home/maria/exclude.txt' "$HOME/Documents/" "$DST_PROFILE/Documents"
#cp -Rvf "$HOME/Documents/" "$DST_PROFILE/Documents"
if [ $? -ne 0 ]; then
    xmessage -buttons Ok:0 -default Ok -nearmouse "Error: backup $DST_PROFILE/Documents failed. Try re-inserting $targetvol."
  #( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.25s ; kill -9 $pid
  #( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.25s ; kill -9 $pid
  #( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.25s ; kill -9 $pid
    exit 1
fi
xmessage -buttons Ok:0 -default Ok -nearmouse "The backup completed successfully."
