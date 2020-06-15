#!/bin/bash

#INPUT variables
buildrepodir="${1}"
templatedir="$(dirname ${0})/xbps"

if [ -z "${buildrepodir}" ] ; then
  echo "Usage:  build-packages.sh [build-repo dir]"
  exit 1
fi
pkgs="trident-base trident-core trident-desktop"
#Copy over the package templates
for pkg in ${pkgs}
do
  if [ -d "${buildrepodir}/srcpkgs/${pkg}" ] ; then
    rm -r "${buildrepodir}/srcpkgs/${pkg}"
  fi
  cp -Rf ${templatedir}/${pkg} ${buildrepodir}/srcpkgs/${pkg}
  if [ $? -ne 0 ] ; then exit 1 ; fi
done

# Update the checksums in the packages (always return errors when changing the file)
cd ${buildrepodir} && xgensum -i srcpkgs/trident-core
cd ${buildrepodir} && xgensum -i srcpkgs/trident-desktop

#Verify that the checksums are correct
cd ${buildrepodir} && xgensum -c srcpkgs/trident-core
if [ $? -ne 0 ] ; then exit 1 ; fi
cd ${buildrepodir} && xgensum -c srcpkgs/trident-desktop
if [ $? -ne 0 ] ; then exit 1 ; fi

#Build the packages
for pkg in ${pkgs}
do
  cd ${buildrepodir} && ./xbps-src pkg ${pkg}
  if [ $? -ne 0 ] ; then exit 1 ; fi
done

#Copy the new packages to this directory
for pkg in ${pkgs}
do
  echo "Copying package: ${pkg}"
  cp ${buildrepodir}/hostdir/binpkgs/${pkg}-*.noarch.xbps .
  if [ $? -ne 0 ] ; then
    echo "[ERROR] Could not copy package: ${pkg}"
  fi
done

# Now cleanup
cd ${buildrepodir} && ./xbps-src clean
