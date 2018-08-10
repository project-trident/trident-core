#!/bin/sh
# Script which does some configuration of the system for laptops/desktops


setupZFSArc(){
  # Tune ZFS ARC 
  ###############################################
  grep -q "vfs.zfs.arc_max" /boot/loader.conf
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
  if [ `rc-update | grep -q powerd` -eq 0 ] ; then
    #one of the powerd[++] service is already setup
    return
  fi
  p_service="powerd"
  if [ -e /usr/local/etc/init.d/powerd++ ] ; then
    #The alternative powerd++ service is installed - use that instead
    p_service="powerd++"
  fi
  rc-update add ${p_service}
  service -N ${p_service} start
}

#figure out if this is a laptop or not (has a battery)
numBat=`apm | grep "Number of batteries:" | cut -d : -f 2`
if [ `apm -a`-gt 3 ] ; then
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

if [ "${type}" = "laptop" ] ; then
  #Turn on power management service (if one is not already setup)
  setupPowerd
  
else
  # Desktop system

fi
#Now ensure the system services are all setup properly
/usr/local/share/trident/scripts/validate-services.sh /usr/local/etc/trident/required-services /usr/local/etc/trident/recommended-services
