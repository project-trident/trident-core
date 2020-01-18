#!/bin/bash
if [ "${STATE}" = "LOGIN" ] ; then
  #Load the system locale settings
  if [ -e "/etc/locale.conf" ] ; then
    source /etc/locale.conf
  fi
  #Load any user-locale settings
  if [ -e "${HOME}/.locale.conf" ] ; then
    source "${HOME}/.locale.conf"
  fi  
  #Failover option if all unset
  if [ -z "${LANG}" ] ; then LANG="en_US.UTF-8" ; fi
  #Now export locale variables as needed
  for _var in LANG LC_ALL LC_MESSAGES LC_TIME LC_NUMERIC LC_MONETARY LC_MESSAGES LC_CTYPE LC_COLLATE
  do
    if [ -n "${!var}" ] ; then
      export ${var}
    fi
  done
  
fi
