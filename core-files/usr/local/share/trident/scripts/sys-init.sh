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
  elif [ $sysMem -lt 4096 ] ; then
    zArc="256"
  else
    zArc="512"
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

setupXProfile(){
  local _script="/usr/local/bin/setup-xorg-session"
  # Check all the .xprofile files in the user home dirs
  # And make sure they launch the x session setup script
  for _hd in $(ls /usr/home)
  do
    if [ ! -e "/usr/home/${_hd}/.xprofile" ] ; then continue; fi
    grep -q "${_script}" "/usr/home/${_hd}/.xprofile"
    if [ $? -ne 0 ] ; then
      echo "
if [ -e \"${_script}\" ] ; then
  . ${_script}
fi
" >> "/usr/home/${_hd}/.xprofile"
    fi
  done
  #Now make sure the default ~/.xprofile exists and/or is setup
  if [ ! -e "/usr/share/skel/dot.xprofile" ] ; then
    echo "# Graphical session setup
# Created by Project Trident
# ===================
if [ -e \"${_script}\" ] ; then
  . ${_script}
fi
" >> "/usr/share/skel/dot.xprofile"

  else
    grep -q "${_script}" "/usr/share/skel/dot.xprofile"
    if [ $? -ne 0 ] ; then
      echo "
if [ -e \"${_script}\" ] ; then
  . ${_script}
fi
" >> /usr/share/skel/dot.xprofile"
    fi
  fi
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

setupLan(){
  for nic in `ifconfig -l`
  do
    #Ignore loopback devices
    echo ${nic} | grep -qE "lo[0-9]"
    if [ 0 -eq $? ] ; then continue; fi
    #See if this device is already configured
    sysrc -ci "ifconfig_${nic}"
    if [ $? -ne 0 ] ; then
      # New ethernet device
      sysrc "ifconfig_${nic}=SYNCDHCP"
      sysrc "ifconfig_${nic}_ipv6=inet6 accept_rtadv"
    fi
  done
}

#figure out if this is a laptop or not
devinfo | grep -q acpi_acad0
if [ $? -eq 0 ] ; then
  type="laptop"
else
  type="desktop"
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

#setup the networking interfaces
setupLan
setupWlan
setupXProfile

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
  ln -s "/usr/local/etc/pulse/default.pa.trident" "/usr/local/etc/pulse/default.pa"
fi



#TrueOS 18.06-18.08 Bug Bypass (8/23/18 - Ken Moore)
# - replace "DHCP" with "SYNCDHCP" in the default-installed /etc/rc.conf
sed -i '' 's|"DHCP|"SYNCDHCP|g' /etc/rc.conf
sed -i '' 's| DHCP"| SYNCDHCP"|g' /etc/rc.conf

#Now ensure the system services are all setup properly
/usr/local/share/trident/scripts/validate-services.sh /usr/local/etc/trident/required-services /usr/local/etc/trident/recommended-services
