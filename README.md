### LIBINPUT-GESTURES

This utility reads libinput gestures from your touchpad using
_libinput-debug-events_ and maps them to gestures you configure in a
configuration file `~/.config/libinput-gestures.conf`. Each gesture can
be configured to activate a shell command which is typically an
[_xdotool_](http://www.semicomplete.com/projects/xdotool/) command to
action desktop/window/application keyboard combinations and commands.
See the examples in the provided `libinput-gestures.conf` file.

This small and simple utility is only intended to be used temporarily
until GNOME and other DE's action libinput gestures natively.
It parses the output of the _libinput-list-devices_ and
_libinput-debug-events_ utilties so is a little fragile to any version
changes in their output format.

This utility is developed and tested on Arch linux with the GNOME
3 DE on Xorg. I am not sure how well this will work on other distros and other
DE's etc.

### INSTALLATION

You need libinput release 1.0 or later. Install prerequisites:

    sudo pacman -S xdotool
    sudo gpasswd -a USER input  # Then log out and back in to assign this group

Then install this software:

    git clone http://github.com/bulletmark/libinput-gestures
    cd libinput-gestures
    make install                # Do this as your normal user, NOT as sudo/root.

### CONFIGURATION

Configure gestures in `~/.config/libinput-gestures.conf` or use the
examples already configured. The available gestures are:

- swipe up
- swipe down
- swipe left
- swipe right
- pinch in
- pinch out

At present, only 3 finger gestures are supported (as
`libinput-debug-events` does not seem to output 4 finger gestures atm?).
Of course, 2 finger swipes and taps are already interpreted by GNOME and
apps for scrolling etc.

IMPORTANT: Test the program. Check for reported errors, missing packages, etc:

    libinput-gestures -d                       # Assuming ~/bin is in your PATH.
    (<ctrl-c> to stop application)

Search for, and then start, the libinput-gestures app in your DE. It
should also start automatically at log in and run in the background.

### REMOVAL

    cd libinput-gestures        # Source dir, as above
    make uninstall

Log out and back in to your DE session to complete installation.

### UPGRADE

    cd libinput-gestures        # Source dir, as above
    git pull
    make install

Log out and back in to your DE session to complete installation.

### LICENSE

Copyright (C) 2015 Mark Blakeney. This program is distributed under the
terms of the GNU General Public License.
This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later
version.
This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License at <http://www.gnu.org/licenses/> for more details.

<!-- vim: se ai syn=markdown: -->
