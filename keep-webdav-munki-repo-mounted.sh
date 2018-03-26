#!/bin/sh
#
timeout=15
remoteserver="example.com"
remoteport=8675
remoteshare="share"
localmountpoint="/Volumes/localmountpoint"
path_to_scripts="script/paths"


mylogline="`date +"%b %d %Y %H:%M:%S"` $0"

get_account () {
  /usr/bin/security find-internet-password -s $remoteserver | grep acct | cut -f4 -d '"' 
}

get_password () {
  /usr/bin/security find-internet-password -ws $remoteserver
}

if mount | grep -q "on $localmountpoint"; then
	/bin/echo "$mylogline $localmountpoint is mounted, no need to mount"
	exit 0
else
	/bin/echo "$mylogline $localmountpoint is Empty, need to mount"
	/bin/mkdir $localmountpoint
	$path_to_scripts/keep-webdav-munki-repo-mounted.exp $remoteserver $remoteport $remoteshare $localmountpoint $(get_account) $(get_password)
fi
