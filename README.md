[![Build Status](https://builds.ixsystems.com/jenkins/buildStatus/icon?job=Trident-Master/Trident%20Master)](https://builds.ixsystems.com/jenkins/job/Trident-Master/job/Trident%20Master/)

# trident-core
Core Packages and system overlay files

## File heirarchy
The "core-files" directory contains a 1:1 mapping of all the files that the "trident-core" package will install. The "core-files" directory gets mapped directly onto the root filesystem ("/").
   * Example: "core-files/boot/loader.conf.local" becomes "/boot/loader.conf.local" when installed
The "pkg" directory contains the FreeBSD port template and script for creating the port for the current git revision.

## Important files
**NOTE:** All of the configuration files listed below will be automatically replaced with newer versions when installing updates. If you want your local-system changes to persist, please place modifications into the designated file as appropriate.

### Project Trident OS Defaults
* [/boot/loader.conf.local](https://github.com/project-trident/trident-core/blob/master/core-files/boot/loader.conf.local) : Default boot-time configuration options (pre-kernel). These can be overwritten by user entries in /boot/loader.conf
* [/etc/rc.conf.d/trident.conf](https://github.com/project-trident/trident-core/blob/master/core-files/etc/rc.conf.d/trident.conf) : Default boot-time configuration options (post-kernel). These can be overwritten by user entries in /etc/rc.conf
* [/etc/sysctl.d/trident-core.conf](https://github.com/project-trident/trident-core/blob/master/core-files/etc/sysctl.d/trident-core.conf) : Default system tuning options. These can be overwritten by user entries in /etc/sysctl.conf
* [/etc/devfs.rules.trident](https://github.com/project-trident/trident-core/blob/master/core-files/etc/devfs.rules.trident) : Default device access permissions. These can be overwritten by creating and adding user entries to /etc/devfs.rules
* [/usr/local/etc/devd/trident-media.conf](https://github.com/project-trident/trident-core/blob/master/core-files/usr/local/etc/devd/trident-media.conf) : Special hooks into the devd subsystem for automatically creating/removing *.desktop files for all removable media in the /media directory.

### Additional System Utilities (shell scripts)
System-wide utilities (all installed into /usr/local/bin)
* [check-tor-mode](https://github.com/project-trident/trident-core/blob/master/core-files/usr/local/bin/check-tor-mode) : Check to see if tor mode is enabled (Return code 0=yes, 1=no)
* [enable-tor-mode](https://github.com/project-trident/trident-core/blob/master/core-files/usr/local/bin/enable-tor-mode) : When run as root, will reconfigure the IPFW firewall to redirect all network traffic through the TOR service.
* [disable-tor-mode](https://github.com/project-trident/trident-core/blob/master/core-files/usr/local/bin/disable-tor-mode) : When run as root, will reconfigure the IPFW firewall back to default configuration (nothing routed through TOR service).
* [mk_zfs_homedir](https://github.com/project-trident/trident-core/blob/master/core-files/usr/local/bin/mk_zfs_homedir) : **PROTOTYPE** Script to create a user's home directory as a ZFS dataset with user access to making/managing snapshots of that directory.
   * **WARNING** This script is just a prototype, and may be removed/renamed at any time depending on developments with the script.
   * Usage: `mk_zfs_homedir <username> [<homedir>=/usr/home [<zpool>=autodetect] ]`
   * Example: `mk_zfs_homedir "myuser" "/home" "pool1"`

### Project Trident Audio System Defaults
Due to the plethora of audio systems on FreeBSD/TrueOS, Project Trident pre-configures several of the audio systems in order to provide a standardized mechanism for managing/controlling audio.

#### Preferred audio systems
* SNDIO (recommended): Use for low-latency audio input/output and application-level audio stream control options.
* OSS: Basic low-latency audio output with in-kernel mixing.

#### Configured audio systems
* Pulseaudio
   * By default, forward all output audio to SNDIO.
   * Trident config file: [/usr/local/etc/pulse/default.pa.trident](https://github.com/project-trident/trident-core/blob/master/core-files/usr/local/etc/pulse/default.pa.trident)
   * System config file: /usr/local/etc/pulse/default.pa (symlink to the Trident config file by default). Replace this link with a real file to overwrite default settings for your local system.
* ALSA
   * By default, forward all output audio to SNDIO.
   * System config file: [/usr/local/etc/asound.conf](https://github.com/project-trident/trident-core/blob/master/core-files/usr/local/etc/asound.conf)
   * No system-level overrides that are update-safe. Place user-level overrides into "~/.asoundrc"
* OpenAL
   * Change the order of preferred audio output: SNDIO, then OSS, then search for other
   * Trident config file: [/usr/local/etc/openal/alsoft.conf](https://github.com/project-trident/trident-core/blob/master/core-files/usr/local/etc/openal/alsoft.conf)
