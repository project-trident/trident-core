#!/bin/sh
# ===================
# Quick script to perform a system sanity check and fix things as needed
#
# ===================

#Verify that config files are setup
# - sudoers
if [ ! -e "/usr/local/etc/sudoers" ] && [ -e "/usr/local/etc/sudoers.dist" ] ; then
  cp "/usr/local/etc/sudoers.dist" "/usr/local/etc/sudoers"
fi
# - cupsd.conf
if [ ! -e "/usr/local/etc/cups/cupsd.conf" ] && [ -e "/usr/local/etc/cups/cupsd.conf.sample" ] ; then
  ln -s "/usr/local/etc/cups/cupsd.conf.sample" "/usr/local/etc/cups/cupsd.conf"
fi
# - sysctl.conf
if [ ! -e "/etc/sysctl.conf" ] ; then
  #if this file is missing, then ALL sysctl config files get ignored. Make sure it exists.
  touch "/etc/sysctl.conf"
fi
# - pulseaudio default.pa
pkg info -e pulseaudio-module-sndio
if [ $? -eq 0 ] && [ ! -e "/usr/local/etc/pulse/default.pa" ] && [ -e "/usr/local/etc/pulse/default.pa.trident" ] ; then
  ln -s "/usr/local/etc/pulse/default.pa.trident" "/usr/local/etc/pulse/default.pa"
fi
# - fonts.conf
if [ ! -e "/usr/local/etc/fonts/fonts.conf" ] && [ -e "/usr/local/etc/fonts/fonts.conf.sample" ] ; then
  ln -s "/usr/local/etc/fonts/fonts.conf.sample" "/usr/local/etc/fonts/fonts.conf"
fi
# - Qt5 qconfig-modules.h include file (supposed to be auto-generated?)
if [ ! -e "/usr/local/include/qt5/QtCore/qconfig-modules.h" ] && [ -e "/usr/local/include/qt5/QtCore/qconfig.h" ] ; then
  touch "/usr/local/include/qt5/QtCore/qconfig-modules.h"
fi

#Ensure that the openrc devd configs are loaded from ports as well
grep -q "/usr/local/etc/devd-openrc" "/etc/devd.conf"
if [ $? -ne 0 ] ; then
  sed -i '' 's|directory "/usr/local/etc/devd";|directory "/usr/local/etc/devd";\
	directory "/usr/local/etc/devd-openrc";|' "/etc/devd.conf"
fi

# Ensure that the icon cache for the "hicolor" theme does not exist
# That cache file will break the auto-detection of new icons per the XDG spec
if [ -e "/usr/local/share/icons/hicolor/icon-theme.cache" ] ; then
  rm "/usr/local/share/icons/hicolor/icon-theme.cache"
fi

#Ensure that the PCDM config file exists, or put the default one in place
if [ ! -e "/usr/local/etc/pcdm.conf" ] ; then
  cp "/usr/local/etc/pcdm.conf.trident" "/usr/local/etc/pcdm.conf"
  #It can contain sensitive info - only allow root to read it
  chmod 700 "/usr/local/etc/pcdm.conf"
fi

# Make sure dbus machine-id file exists
if [ ! -L "/etc/runlevels/default/dbus" ] ; then
  # QT needs a valid dbus machine-id file even if dbus is not used/started
  if [ ! -e "/var/lib/dbus/machine-id" ] ; then
    /usr/local/bin/dbus-uuidgen --ensure
  fi
fi

# Always update the default wallpaper symlink
ln -s "/usr/local/share/wallpapers/trident/trident_blue_4K.png" "/usr/local/share/wallpapers/trident/default.png"

#Ensure that the /sbin/service utility exists
if [ ! -e "/sbin/service" ] ; then
  if [ -e "/usr/sbin/service" ] ; then
    ln -s "/usr/sbin/service" "/sbin/service"
  else
    echo "[WARNING] Could not find the service utility!"
  fi
fi
