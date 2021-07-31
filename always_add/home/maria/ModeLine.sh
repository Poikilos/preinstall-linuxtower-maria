#!/bin/bash
#cvt 1280 720 60
#Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#sudo xrandr --newmode "1280x720_60.00" 74.50 1280 1344 1472 1644  720 723 728 748 -hsync +vsync
sudo xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
sudo xrandr --addmode VGA-1 "1920x1080_60.00"
