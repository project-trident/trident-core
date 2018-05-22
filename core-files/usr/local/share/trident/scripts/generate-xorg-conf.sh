#!/bin/sh
##############
# Simple script to setup the xorg.conf file as needed
# INPUTS: 
#   1: driver to use or "auto" to auto-detect the best driver
#   2: [optional: /etc/X11/xorg.conf default] path to config file to create
##############

#Get the inputs
driver=$1
file=$2
if [ -z "${file}" ] ; then
  file="/etc/X11/xorg.conf"
fi

#If auto is selected, determine the best driver
if [ "${driver}" = "auto" ] ; then
  driver=`/usr/local/share/trident/scripts/detect-best-driver.sh`
fi
#Get the bus ID for the video card
busid=`pciconf -lv vgapci0 | grep vgapci0 | cut -d : -f 2-4`

#Now copy over the xorg.conf template and replace the driver/busid in it
template="/usr/local/share/trident/xorg-templates/xorg.conf"
cp -f "${template}" "${file}"
sed -i '' "s|%%BUSID%%|${busid}|g" "${file}"
sed -i '' "s|%%DRIVER%%|${driver}|g" "${file}"
