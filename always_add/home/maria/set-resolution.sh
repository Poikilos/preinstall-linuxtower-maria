#!/bin/sh
out="$HOME/set-resolution.log"
date > "$out"

# How to get the mode line: Use the 'cvt' command (See ModeLine.sh).


# mac mini:
#xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync

# hp Core 2 Duo (bad card, no longer supported):
#xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync

# new GT710 on hp Core 2 Duo:
# xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
# xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
if [ $? -ne 0 ]; then
    echo "Error: 'xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync' failed." >> "$out"
fi

# hp Core 2 Duo (bad card, no longer supported):
# xrandr --addmode VGA-1 "1280x720_60.00"

# new GT710 on hp Core 2 Duo (name found via xrandr):
xrandr --addmode VGA-0 "1280x720_60.00"
if [ $? -ne 0 ]; then
    #echo "Error: 'xrandr --addmode VGA-1 \"1280x720_60.00\"' failed."
    echo "Error: 'xrandr --addmode VGA-0 \"1280x720_60.00\"' failed." >> "$out"
fi
# ^ VGA1 on mac mini
echo "Done" >> "$out"
