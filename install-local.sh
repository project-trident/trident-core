#!/bin/sh
#Quick Script for installing core files on the local system
###########################
#  INPUTS: 
#      $1: path to installation directory (optional - only use when preparing to make a package)
#      $2: Package files to install ([something]-files directory tree). This can be a list of multiple package files
#           Example: "core" will install everything under the "core-files" directory structure
###########################
install_dir="$1"
install_files="$2"

#validate the inputs
if [ -z "${install_dir}" ] ; then
  install_dir="/"
fi
if [ -z "${install_files}" ] ; then
  install_files="core"
fi

#Make sure the install directory exists
if [ ! -d "${install_dir}" ] ; then
  #Create the install dir first
  mkdir -p "${install_dir}"
fi

# Start installing the files
echo "Copying Files to: ${install_dir}"
for files in ${install_files}
do
  echo " - Copy Package Files: ${files}"
  cp -R "${files}-files/" "${install_dir}/."
done
echo "Done"
