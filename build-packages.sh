#!/bin/bash

#INPUT variables
buildrepodir="${1}"
templatedir="$(dirname ${0})/xbps"

#Copy over the package templates
cp -R ${templatedir}/trident-core ${buildrepodir}/srcpkgs/trident-core
if [ $? -ne 0 ] ; then exit 1 ; fi
cp -R ${templatedir}/trident-desktop ${buildrepodir}/srcpkgs/trident-desktop
if [ $? -ne 0 ] ; then exit 1 ; fi

# Update the checksums in the packages (always return errors when changing the file)
cd ${buildrepodir} && xgensum -i srcpkgs/trident-core
cd ${buildrepodir} && xgensum -i srcpkgs/trident-desktop

#Verify that the checksums are correct
cd ${buildrepodir} && xgensum -c srcpkgs/trident-core
if [ $? -ne 0 ] ; then exit 1 ; fi
cd ${buildrepodir} && xgensum -c srcpkgs/trident-desktop
if [ $? -ne 0 ] ; then exit 1 ; fi

#Build the packages
cd ${buildrepodir} && ./xbps-src pkg trident-desktop
if [ $? -ne 0 ] ; then exit 1 ; fi

#Copy the new packages to this directory
cp ${buildrepodir}/hostdir/binpkgs/trident-core-*.noarch.xbps .
cp ${buildrepodir}/hostdir/binpkgs/trident-desktop-*.noarch.xbps .

# Now cleanup
cd ${buildrepodir} && ./xbps-src clean
