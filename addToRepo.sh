#!/bin/bash
# Input Variables
pkg_orig="${1}"
pkg_file="$( basename ${pkg_orig})"
privkey="${2}"
repoLocal="${3}"

showUsage() {
  echo "Usage:
  addToRepo.sh [*.xbps] [*.pem]

  *.xbps : Package file to sign and add to repo
  *.pem : Private OpenSSL key (RSA+PEM) to use when signing packages
"
  exit 1
}

# NOTE: If the private key has a passphrase, you can set the
#  XBPS_PASSPHRASE environment variable to use it non-interactively
#  export XBPS_PASSPHRASE="test"


# Repository access settings
signedby='Project Trident'
repoHost="project-trident.org"
repoRemoteDir="/usr/local/www/trident-packages/repo"
repoUser="root"
if [ -z "${repoLocal}" ] ; then
  repoLocal="$(pwd)/repo"
fi

# List of architectures to support with this repo
#  (repo must have no-arch package builds only)
archs="x86_64 x86_64-musl ppc64le ppc64le-musl"

#Ensure needed utilities are available
needs="rsync xbps-rindex uname"
ok=0
for _need in ${needs}
do
  if [ ! -f "/usr/bin/${_need}" ] ; then
    echo "Could not find utility: ${_need}"
    ok=1
  fi
done
if [ ${ok} -eq 1 ] ; then exit 1; fi
#Ensure that the required inputs are provided
if [ ! -f "${pkg_orig}" ] || [ ! -f "${privkey}" ] ; then
  showUsage
fi

#Populate some needed variables automatically
cur_arch=$(uname -m) #current architecture

if [ ! -d "${repoLocal}" ] ; then
  mkdir -p "${repoLocal}"
fi
# Step 1 : Rsync the repo dir from remote to local system
rsync -acpP ${repoUser}@${repoHost}:${repoRemoteDir}/ "${repoLocal}/"

# Step 2 : Add the new package and sign it
cp "${pkg_orig}" "${repoLocal}/"
# Step 2B : Create/sign the repo itself if it does not already exist
xbps-rindex --privkey "${privkey}" --sign --signedby "${signedby}" "${repoLocal}/"
xbps-rindex -v --signedby "${signedby}" --privkey "${privkey}" --sign-pkg "${repoLocal}/${pkg_file}"
xbps-rindex -a ${repoLocal}/*.xbps
xbps-rindex -c "${repoLocal}"
xbps-rindex -r "${repoLocal}"
# Step 3 : Update all the repository index files to match
for _arch in ${archs}
do
  if [ "${cur_arch}" = "${_arch}" ] ; then continue ; fi
  cp "${repoLocal}/${cur_arch}-repodata" "${repoLocal}/${_arch}-repodata"
done

# Step 4 : Rsync the local repo back upstream
rsync -acpP "${repoLocal}/" ${repoUser}@${repoHost}:${repoRemoteDir}/

# Step 5 : Issue the website rebuild on the remote server
ssh ${repoUser}@${repoHost} /root/trident-website/deploy_hugo.sh
