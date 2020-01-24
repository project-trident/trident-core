#!/bin/bash
if [ "${STATE}" = "LOGIN" ] ; then
  dbus-launch --exit-with-x11
  start-pulseaudio-x11
  pulseaudio --check
  if [ $? -eq 1 ] ; then
    pulseaudio --start
  fi
elif [ "${STATE}" = "LOGOUT" ] ; then
  pulseaudio -k
fi
