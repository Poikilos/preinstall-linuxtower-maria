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

# new GT710 on hp Core 2 Duo with incorrect driver version 470:
#xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
# new GT710 on hp Core 2 Duo with correct driver version 390:
#xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
# ^ has error:
cat > /dev/null <<END
X Error of failed request:  BadName (named color or font does not exist)
  Major opcode of failed request:  140 (RANDR)
  Minor opcode of failed request:  16 (RRCreateMode)
  Serial number of failed request:  33
  Current serial number in output stream:  33
END

#xrandr --newmode "1280x720_75.00"   95.75  1280 1360 1488 1696  720 723 728 755 -hsync +vsync
# ^ odd, it has the same error but only the second time it runs. It must just be a duplicate name conflict.
# ^ The resolution isn't listed in xrandr, so try:
# xrandr --newmode "1440x900_60.00"  106.50  1440 1528 1672 1904  900 903 909 934 -hsync +vsync
# xrandr --newmode "1440x900_59.89"  106.25  1440 1528 1672 1904  900 903 909 934 -hsync +vsync
xrandr --newmode "1440x900_60.00"  106.50  1440 1528 1672 1904  900 903 909 934 -hsync +vsync


# xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
if [ $? -ne 0 ]; then
    #echo "Error: xrandr --newmode failed \"1280x720_60.00\"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync' failed." >> "$out"
    echo "Error: xrandr --newmode failed \"1280x720_60.00\"" >> "$out"
fi

# hp Core 2 Duo (bad card, no longer supported):
# xrandr --addmode VGA-1 "1280x720_60.00"

# xrandr --addmode VGA-0 "1280x720_60.00"
# new GT710 with DVI-D cable on hp Core 2 Duo (name found via xrandr):
#xrandr --addmode DVI-D-0 "1280x720_60.00"
#xrandr --addmode DVI-D-0 "1280x720_60.00"
# ^ 1280x720 isn't listed for xrandr on driver version 390

xrandr --addmode DVI-D-0 "1440x900_60.00"
# xrandr --addmode "1440x900_59.89"
if [ $? -ne 0 ]; then
    #echo "Error: 'xrandr --newmode VGA-1 \"1280x720_60.00\"' failed."
    echo "Error: 'xrandr --addmode' failed." >> "$out"
fi
# ^ VGA1 on mac mini
echo "Done" >> "$out"
echo "The script doesn't seem to be necessary. Try /home/maria/git/preinstall-linuxtower-maria/setup-nvidia.sh" >> "$out"
