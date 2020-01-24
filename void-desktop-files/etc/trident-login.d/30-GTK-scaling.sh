#Setup GDK/Mozilla environment settings
if [ "${STATE}" = "LOGIN" ] ; then
  # Fix an issue with large image rendering via mozilla
  export MOZ_DISABLE_IMAGE_OPTIMIZE=1

  # Detect the current DPI and try to automatically set the GTK scale factor
  if [ -x /usr/bin/xdpyinfo ] ; then
    DPI=`xdpyinfo | grep resolution | tr -s '[:space:]' | cut -d ' ' -f 3 | cut -d x -f 1`
    #Text scaling (2 decimel places)
    export GDK_DPI_SCALE=`echo "scale = 2 ; ${DPI} / 96" | bc`
    #All Scaling (whole numbers only)
    #export GDK_SCALE=
  fi
fi
