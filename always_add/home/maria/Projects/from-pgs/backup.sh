#!/bin/sh
customDie() {
    echo
    echo
    echo "ERROR:"
    echo "$1"
    echo
    echo
    exit 1
}

EXCLUDE_TXT=exclude_from_backup.txt

if [ ! -f "$EXCLUDE_TXT" ]; then
    echo "cd $HOME..."
    cd "$HOME" || customDie "cd \"$HOME\" #failed."
fi

if [ ! -f "$EXCLUDE_TXT" ]; then
    customDie "\"$EXCLUDE_TXT\" is missing from \"`pwd`\"."
fi

if [ ! -z "$1" ]; then
    DEST_PATH="$1"
    echo "* destination is now $DEST_PATH"
fi
BACKUPS_PATH="/run/media/owner/JGustafsonExt"

if [ -z "$DEST_PATH" ]; then
    DEST_PATH="$BACKUPS_PATH/pgs/HOME"
fi

if [ -d "$DEST_PATH" ]; then
    echo "* You must specify an existing path as a parameter or mount the external drive such that the default '$DEST_PATH' exists."
fi

if [ -z "$PULL_NAME" ]; then
    PULL_NAME="buzzy"
fi
if [ -z "$PULL_MNT" ]; then
    PULL_MNT=/mnt/$PULL_NAME
fi
if [ -z "$PULL_SRC" ]; then
    PULL_SRC=$PULL_MNT/home/pi
fi
if [ -z "$PULL_DST" ]; then
    # PULL_DST="$HOME/Backup/$PULL_NAME/home/pi"
    # PULL_DST="/nfs/cloud/backup/$PULL_NAME/home/pi"
    PULL_DST="$BACKUPS_PATH/buzzy/home/pi"
fi
if [ -d "$PULL_SRC" ]; then
    echo "* Backing up $PULL_NAME..."
    if [ -d "$PULL_DST" ]; then
        # mkdir -p "$PULL_DST" || customDie "'mkdir -p \"$PULL_DST\"' failed."
        rsync -a --info=progress2 --delete "$PULL_SRC/" "$PULL_DST" || customDie "'rsync -a --info=progress2 --delete \"$PULL_SRC/\" \"$PULL_DST\"' failed."
        echo "  * Backing up $PULL_NAME finished successfully."
    else
        echo "  * Backing up $PULL_NAME skipped since \"$PULL_DST\" does not exist."
    fi
else
    echo "* '$PULL_MNT' is not mounted, so backing up $PULL_SRC to $PULL_DST will not occur."
fi

if [ -d "$DEST_PATH" ]; then
    echo "* Backing up $HOSTNAME to '$DEST_PATH'..."
    # rsync -rtv --exclude 'Cache' /home/owner/ "$DEST_PATH"
    # rsync -rtv --exclude '.cache' /home/owner/ "$DEST_PATH"
    rsync -rtv --exclude-from "$EXCLUDE_TXT" --info=progress2 /home/owner/ "$DEST_PATH" || customDie "'rsync -rtv --exclude-from \"$EXCLUDE_TXT\" /home/owner/ \"$DEST_PATH\"' failed."
    echo "  * Backing up $HOSTNAME to '$DEST_PATH' finished successfully."
else
    echo "* ERROR: Backup of $HOSTNAME is not complete done since '$DEST_PATH' is not present."
fi
