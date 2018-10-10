#!/bin/sh
#Quick script to detect when VirtualBox is getting used (via guest additions module load)
# And disable the back button (mouse button 6). 
# Since we keep getting "phantom" clicks of that button on wheel events
kldstat | grep -q "vboxguest"
if [ $? -eq 0 ] && [ -e "/usr/local/bin/xinput" ] ; then
  #Virtualbox guest extensions loaded
  #Disable the forward/back mouse buttons (8 & 9)
  xinput --set-button-map "sysmouse" 1 2 3 4 5 6 7 0 0
fi
