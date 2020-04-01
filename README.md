# trident-core
Core Packages and system overlay files

## File hierarchy
* The "void-files" directory contains a 1:1 mapping of all the files that the "trident-core" package will install. The "void-files" directory gets mapped directly onto the root filesystem ("/").
   * Example: "void-files/boot/loader.conf.local" becomes "/boot/loader.conf.local" when installed
   * The "void-files/usr/bin/trident-sysinit" utility automatically runs
* The "void-desktop-files" directory contains a 1:1 mapping of the files that the "trident-desktop" package will install.
* The "xbps" directory contains the Void Linux port templates for these packages (checksums will probably need to be re-generated first though)

## Important files
**NOTE:** All of the configuration files listed below will be automatically replaced with newer versions when installing updates. If you want your local-system changes to persist, please place modifications into the designated file(s) as appropriate.

### Additional System Utilities (shell scripts)
System-wide utilities (all installed into /usr/bin)

### trident-update (trident-core package)
This is a wrapper around the Void Linux update mechanisms, with additional safeguards and checks built-in.

Usage:

* `trident-update -check` : Check for updates
   * Will automatically bootstrap `xbps` itself as needed (with a BE snapshot beforehand)
* `trident-update -update` : Perform system updates
   * Will automatically bootstrap `xbps` itself as needed (with a BE snapshot beforehand).
   * This will also prune out all the old kernel versions that may be around (cleaning up the system)
   * This creates a snapshot of the current BE before any modifications occur (in case you need to roll back).

### trident-mkuser (trident-core package)
This is a script for creating user accounts programmatically. This also ensures that user accounts are setup with encrypted ZFS homedirs as needed.

Usage: (To-Do, need to write docs)

### trident-login (trident-desktop package)
This is a user-level login routine which allows for DE-agnostic login setup and customization on a system or per-user basis.
This is automatically called by the desktop init routines

Important directories:

* "/etc/trident-login.d" : System-wide scripts to be run during login (impacts all users)

Important files (Not fully implemented yet):

* "/etc/trident.conf"
* "~/.config/trident.conf"

These are the system and user level configuration files for trident-init. These may be used to interact with or modify the trident-login routines on a system-wide or per-user basis. Any settings in the user file will overwrite the same setting in the system file.
  
