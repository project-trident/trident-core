#!/bin/sh
#Quick script to probe and re-generate the list of fonts that Xorg can use
#  based on what is installed on the system

_conf="/usr/local/etc/X11/xorg.conf.d/trident-xorg-files.conf"

_tmp="Section \"File\"
  ModulePath    \"/usr/local/lib/modules\"
  ModulePath    \"/usr/local/lib/xorg/modules\""

#Now probe for installed fonts and add them to the list
for _font in `find /usr/local/share/fonts | grep fonts.dir`
do
  _fontdir=`dirname ${_font}`
  _tmp="${_tmp}
  FontPath     \"${_fontdir}\""
done
#Now close off the section
_tmp="${_tmp}
EndSection
"
# And save it over the built-in xorg.conf.d config file
echo "${_tmp}" > "${_conf}"
