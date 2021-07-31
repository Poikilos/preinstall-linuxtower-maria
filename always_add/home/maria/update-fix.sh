#!/bin/bash
#Fix gpg error google repos (https://askubuntu.com/questions/1078813/the-repository-http-dl-google-com-linux-chrome-deb-stable-release-does-not-h):
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

#apt update
#Failed to fetch http://dl.google.com/linux/earth/deb/dists/stable/Release.gpg
#Bad header line Bad header data [IP: 142.250.191.206 80]

#fix (https://askubuntu.com/questions/162782/apt-get-update-bad-header-line-on-all-updates):
sudo rm -rf /var/lib/apt/lists/* && sudo apt-get update

## Tasks
# - fix: "N: Skipping acquire of configured file 'main/binary-i386/Packages' as repository 'http://dl.google.com/linux/earth/deb stable InRelease' doesn't support architecture 'i386'"
