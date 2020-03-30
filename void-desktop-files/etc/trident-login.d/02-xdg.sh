if [ "${STATE}" = "LOGIN" ] ; then
  #Setup XDG environment variables (may be modified by DE/WM later)
  export XDG_DATA_DIRS="/share:/usr/share"
  export XDG_DATA_HOME="${HOME}/.local/share"
  export XDG_CONFIG_DIRS="/etc/xdg"
  export XDG_CONFIG_HOME="${HOME}/.config"
  export XDG_RUNTIME_DIR="/tmp/.runtime-${USER}"

  #Ensure the XDG runtime directory exists and is only read/write by the user
  if [ ! -d "${XDG_RUNTIME_DIR}" ] ; then
    mkdir -m 700 "${XDG_RUNTIME_DIR}"
    chown "${USERNAME}:${USERNAME}" "${XDG_RUNTIME_DIR}"
  fi

  #Check the standardized user directories and create them as needed
  if [ -x /usr/bin/xdg-user-dirs-update ] ; then
    xdg-user-dirs-update
  fi

elif [ "${STATE}" = "LOGOUT" ] ; then
  #Need to delete the XDG RUNTIME directory during logout
  if [ -e "${XDG_RUNTIME_DIR}" ] && [ "${XDG_RUNTIME_DIR}" != "/" ] ; then
    #Note: This runs with user permissions
    # So it can only remove the directory if it is owned by the user (as setup during login)
    rm -rf "${XDG_RUNTIME_DIR}"
  fi
fi
