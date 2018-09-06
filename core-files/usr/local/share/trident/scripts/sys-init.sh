#!/bin/sh
# Script which does some configuration of the system for laptops/desktops


setupZFSArc(){
  # Tune ZFS ARC 
  ###############################################
  grep -q "vfs.zfs.arc_max=" /boot/loader.conf
  if [ $? -eq 0 ] ; then
    return 0 #Do not overwrite current ARC settings
  fi

  # Get system memory in bytes
  sysMem=`sysctl hw.physmem | cut -w -f 2`
  # Get that in MB
  sysMem=`expr $sysMem / 1024 / 1024`
  # Set some default zArc sizes based upon RAM of system
  if [ $sysMem -lt 1024 ] ; then
    zArc="128"
  elif [ $sysMem -lt 2048 ] ; then
    zArc="256"
  elif [ $sysMem -lt 4096 ] ; then
    zArc="512"
  else
    zArc="1024"
  fi

  echo "# Tune ZFS Arc Size - Change to adjust memory used for disk cache" >> /boot/loader.conf
  echo "vfs.zfs.arc_max=\"${zArc}M\"" >> /boot/loader.conf
}

setupPowerd(){
  rc-update | grep -q powerd
  if [ $? -eq 0 ] ; then
    #one of the powerd[++] service is already setup
    return
  fi
  p_service="powerd"
  if [ -e "/usr/local/etc/init.d/powerd++" ] ; then
    #The alternative powerd++ service is installed - use that instead
    p_service="powerd++"
  fi
  rc-update add ${p_service} default
}

setupWlan(){
  # Check for any new wifi devices to setup
  for wnic in `sysctl -n net.wlan.devices 2>/dev/null`
  do
    #See if this device is already configured
    grep -q "wlans_${wnic}" /etc/rc.conf
    if [ $? -ne 0 ] ; then
      # New wifi device - determine the next number for it
      grep -qE "^wlans_" /etc/rc.conf
      if [ $? -eq 0 ] ; then
        WLANCOUNT=`cat /etc/rc.conf | grep -E "^wlans_" | wc -l | awk '{print $1}'`
      else
        WLANCOUNT="0"
      fi
      WLAN="wlan${WLANCOUNT}"
      # Save the wlan interface
      echo "wlans_${wnic}=\"${WLAN}\"" >> /etc/rc.conf
      echo "ifconfig_${WLAN}=\"WPA SYNCDHCP\"" >> /etc/rc.conf
      echo "ifconfig_${WLAN}_ipv6=\"inet6 accept_rtadv\"" >> /etc/rc.conf
    fi
  done
}

#figure out if this is a laptop or not (has a battery)
numBat=`apm | grep "Number of batteries:" | cut -d : -f 2`
if [ $? -ne 0 ] || [ $numBat -lt 1 ] ; then
  #invalid apm battery status = no batteries
  type="desktop"
else
  type="laptop"
fi

################################################
# Verify generic init
################################################

if [ ! -d "/usr/home" ] ; then
   mkdir /usr/home
fi

# Setup /home link (for people used to Linux, and some applications)
if [ ! -e "/home" ] ; then
  ln -s /usr/home /home
fi

#Check/set the ZFS arc size
setupZFSArc

#Turn on power management service (if one is not already setup)
setupPowerd

if [ "${type}" = "laptop" ] ; then
  # Laptop system
  # TO-DO  
else
  # Desktop system
  # TO-DO
fi

#setup the wireless devices (if any)
setupWlan

#Verify that config files are setup
# - sudoers
if [ ! -e "/usr/local/etc/sudoers" ] && [ -e "/usr/local/etc/sudoers.dist" ] ; then
  cp "/usr/local/etc/sudoers.dist" "/usr/local/etc/sudoers"
fi
# - cupsd.conf
if [ ! -e "/usr/local/etc/cups/cupsd.conf" ] && [ -e "/usr/local/etc/cups/cupsd.conf.sample" ] ; then
  cp "/usr/local/etc/cups/cupsd.conf.sample" "/usr/local/etc/cups/cupsd.conf"
fi
# - pulseaudio default.pa
if [ ! -e "/usr/local/etc/pulse/default.pa" ] && [ -e "/usr/local/etc/pulse/default.pa.trident" ] ; then
  cp "/usr/local/etc/pulse/default.pa.trident" "/usr/local/etc/pulse/default.pa"
fi



#TrueOS 18.06-18.08 Bug Bypass (8/23/18 - Ken Moore)
# - replace "DHCP" with "SYNCDHCP" in the default-installed /etc/rc.conf
sed -i '' 's|"DHCP|"SYNCDHCP|g' /etc/rc.conf

#Now ensure the system services are all setup properly
/usr/local/share/trident/scripts/validate-services.sh /usr/local/etc/trident/required-services /usr/local/etc/trident/recommended-services
