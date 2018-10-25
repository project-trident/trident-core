#!/bin/sh
#============
#Quick script to scan your system and compare the installed packages
# to a package.list file from Project Trident, and warn about missing packages
#============
# INPUTS:
#  $1: path to package.list file
#============
listfile=$1
if [ -z "${listfile}" ] ; then
  listfile="release"
fi


if [ "${listfile}" = "release" ] || [ "${listfile}" = "stage" ] ; then
  tmpfile="/tmp/.tmppkg_compare.list"
  echo "Fetching latest pkg.list from Project Trident: ${listfile}"
  fetch "http://pkg.project-trident.org/iso/${listfile}/pkg.list" -o "${tmpfile}"
  listfile="${tmpfile}"
fi

if [ ! -e "${listfile}" ] ; then
  echo "[ERROR] Could not find pkg.list file: ${listfile}"
  return 1
fi

#Make sure we skip all the base packages
echo "Scanning pkg.list for missing packages...."
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

#Cleanup temporary download file as needed
if [ -e "${tmpfile}" ] && [ -n "${tmpfile}" ] ; then
  rm "${tmpfile}"
fi
