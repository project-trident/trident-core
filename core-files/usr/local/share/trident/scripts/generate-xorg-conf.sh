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


createDriverBlock(){
  # INPUTS: 
  # 1: device (vgapci0 by default)
  # 2: driver (automatic by default)
  local _device="$1"
  local _driver="$2"
  if [ -z "${_device}" ] ; then
    _device="vgapci0"
  fi
  if [ -z "${_driver}" ] || [ "auto" = "${_driver}" ] ; then
    _driver=`/usr/local/share/trident/scripts/detect-best-driver.sh "${_device}"`
  fi
  local busid=`pciconf -l "${_device}" | cut -d : -f 2-4`
  local cardnum=`echo "${_device}" | tail -c 2`
  local options
  if [ "${_driver}" = "intel" ] || [ "${_driver}" = "modesetting" ] ; then
    #Disable GPU accelleration for intel/modesetting - causes graphical artifacting (TrueOS 18.06)
    options="Option   \"AccelMethod\"   \"none\""
  fi
#Add the device section to the 
  echo "Section \"Device\"
  Identifier      \"Card${cardnum}\"
  Driver          \"${_driver}\"
  BusID           \"${busid}\"
  ${options}
EndSection
" >> ${file}
}

#Now copy over the xorg.conf template
template="/usr/local/share/trident/xorg-templates/xorg.conf"
cp -f "${template}" "${file}"

#If auto is selected, determine the best driver
if [ "${driver}" = "auto" ] || [ -z "${driver}" ] ; then
  for dev in `pciconf -l | grep vgapci | cut -w -f 1`
  do
    createDriverBlock "${dev}"
  done
else
  createDriverBlock "vgapci0" "${driver}"
fi
