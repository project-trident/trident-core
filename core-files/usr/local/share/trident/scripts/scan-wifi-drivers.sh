#!/bin/sh
# Quick script to scan for available wifi devices and then load/unload the different modules to see which ones are needed.

curdev=$(sysctl -n net.wlan.devices)

for module in `ls /boot/kernel/if_*.ko`
do
  modname=$( basename ${module} | cut -d . -f 1 )
  kldstat -q -m "${modname}"
  if [ $? -eq 1 ] ; then
    #Module not currently loaded, test it
    kldload -nq "${modname}"
    if [ $? -eq 0 ] ; then
      if [ "${curdev}" != "$(sysctl -n net.wlan.devices)" ] ; then
        # New devices found - add it to loader.conf
        echo "Found new wifi devices with module: ${modname}"
        echo "${modname}_load=\"YES\"" >> /boot/loader.conf
      fi
      kldunload -q "${modname}"
    fi
  fi
done
