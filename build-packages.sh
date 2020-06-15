#!/bin/bash

#INPUT variables
buildrepodir="${1}"
templatedir="$(dirname ${0})/xbps"

pkgs="trident-base trident-core trident-desktop"
#Copy over the package templates
for pkg in ${pkgs}
do
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
  cp ${buildrepodir}/hostdir/binpkgs/${pkg}-*.noarch.xbps .
done

# Now cleanup
cd ${buildrepodir} && ./xbps-src clean
