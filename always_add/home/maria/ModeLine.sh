#!/bin/bash

# How to get:
#   cvt 1920 1080 60
#   cvt 1280 720 60

#mac mini:
#Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync

#hp Core 2 Duo:
#Modeline "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync

#sudo xrandr --newmode "1280x720_60.00" 74.50 1280 1344 1472 1644  720 723 728 748 -hsync +vsync

#sudo xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#sudo xrandr --addmode VGA-1 "1920x1080_60.00"
#^ 1920x1080 makes fonts too small, and Xubuntu's Appearance panel only has 1x or 2x (too big).

# See .profile which runs the lines automatically (not with sudo!).
