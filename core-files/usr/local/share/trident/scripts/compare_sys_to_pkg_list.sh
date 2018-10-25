#!/bin/sh
#============
#Quick script to scan your system and compare the installed packages
# to a package.list file from Project Trident, and warn about missing packages
#============
# INPUTS:
#  $1: path to package.list file
#============
listfile=$1

#Make sure we skip all the base packages
_missing=0
for _pkg in `pkg query -a %n | grep -v -E "^(FreeBSD|TrueOS|OS)-"`
do
  grep -q "${_pkg}" "${listfile}"
  if [ $? -ne 0 ] ; then
    _missing=`expr ${_missing} + 1`
    _missinglist="${_missinglist}
${_pkg}"
  fi
done
if [ ${_missing} -gt 0 ] ; then
  echo "Missing Packages (${_missing}) 
========${_missinglist}"
else
  echo "No Missing Packages!"
fi
