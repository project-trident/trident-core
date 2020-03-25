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

CARDNUM=-1
createDriverBlock(){
  # INPUTS: 
  # 1: device (vgapci0 by default)
  # 2: driver (automatic by default)
  # OUTPUTS:
  #  $CARDNUM (number) : only set if the input device should be used as the primary GPU
  local _device="$1"
  local _driver="$2"
  if [ -z "${_device}" ] ; then
    _device="vgapci0"
  fi
  if [ -z "${_driver}" ] || [ "auto" = "${_driver}" ] ; then
    #Need to determine which drivers are available for this device
    _driver=`/usr/local/share/trident/scripts/detect-best-driver.sh "${_device}"`
  elif [ "fallback" = "${_driver}" ] ; then
    #automatically determine the proper fallback driver
    _driver=`/usr/local/share/trident/scripts/detect-best-driver.sh "${_driver}"`
  fi
  if [ $? -ne 0 ] ; then
    #error in driver detection - just use vesa a bare-minimum fallback
    _driver="vesa"
  fi
  local busid=`pciconf -l "${_device}" | cut -d : -f 2-4`
  local cardnum=`echo "${_device}" | tail -c 2`
  local options
  if [ "${_driver}" = "intel" ] || [ "${_driver}" = "modesetting" ] ; then
    #Disable GPU accelleration for intel/modesetting - causes graphical artifacting (TrueOS 18.06)
    sysset=$(sysrc -ni "disable_intel_accel")
    if [ $? -ne 0 ] ; then sysset="YES" ; fi
    if [ "${sysset}" = "YES" ] || [ "${sysset}" = "yes" ] ; then
      options="Option   \"AccelMethod\"   \"none\""
    fi
    #Also save this card number as the primary if on a laptop (NVIDIA optimus?)
    devinfo | grep -q acpi_acad0
    if [ $? -eq 0 ] && [ ${CARDNUM} -lt 0 ]; then
      #Got a laptop - go ahead and save this intel GPU as the primary
      #This will *only* activate for the first Intel GPU found. It will not select later Intel GPU's by default
      CARDNUM=${cardnum}
    fi
  fi
  #Add the device section 
  if [ "${_driver}" = "vesa" ] || [ "${_driver}" = "scfb" ] ; then
    #Do not setup the BusID section for the fallback drivers
    echo "Section \"Device\"
  Identifier      \"Card${cardnum}\"
  Driver          \"${_driver}\"
  ${options}
EndSection
" >> ${file}
  else
    #Do the full device section
    echo "Section \"Device\"
  Identifier      \"Card${cardnum}\"
  Driver          \"${_driver}\"
  BusID           \"${busid}\"
  ${options}
EndSection
" >> ${file}
  fi
}

#Now copy over the xorg.conf template
template="/usr/local/share/trident/xorg-templates/xorg.conf"
cp -f "${template}" "${file}"

#If auto is selected, determine the best driver
# Note: the CARDNUM variable will return the number of the GPU to use (typically 0)
if [ "${driver}" = "auto" ] || [ -z "${driver}" ] ; then
  for dev in `pciconf -l | grep vgapci | cut -d @ -f 1`
  do
    createDriverBlock "${dev}"
  done
else
  createDriverBlock "vgapci0" "${driver}"
fi
if [ ${CARDNUM} -lt 0 ] ; then
  CARDNUM=0 #No special cardnum found - use the default
fi
sed -i '' "s|%%CARDNUM%%|${CARDNUM}|g" "${file}"
