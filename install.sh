#!/bin/bash
# Installation script.
# (C) Mark Blakeney, markb@berlios.de, Sep 2015.

PROG="libinput-gestures"
BINDIR="$HOME/bin"
APPDIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
AUTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"

usage() {
    echo "Usage: $(basename $0) [-options]"
    echo "Options:"
    echo "-s <stop if running>"
    echo "-r <stop if running and remove/uninstall>"
    echo "-x <start running after install>"
    echo "-f <force install/remove conf file>"
    echo "-d <do not install DE desktop/startup files>"
    exit 1
}

STOP=0
REMOVE=0
START=0
FORCE=0
NO_DESKTOP=0
while getopts srxfd c; do
    case $c in
    s) STOP=1;;
    r) REMOVE=1;STOP=1;;
    x) START=1;;
    f) FORCE=1;;
    d) NO_DESKTOP=1;;
    ?) usage;;
    esac
done

shift $((OPTIND - 1))

if [ $# -ne 0 ]; then
    usage
fi

if [ "$(id -un)" = "root" ]; then
    echo "Don't install/uninstall as root/sudo. Just run as your own user."
    exit 1
fi

# Delete or list file/dir
clean() {
    local tgt=$1

    if [ -e $tgt -o -h $tgt ]; then
	if [ -d $tgt ]; then
	    echo "Removing $tgt/"
	else
	    echo "Removing $tgt"
	fi
	rm -rf $tgt
    fi
}

if [ $STOP -ne 0 ]; then
    for prog in libinput-debug-events libinput-gestures; do
	if pkill -f $prog; then
	    echo "$prog stopped."
	elif pkill -s0 -f $prog; then
	    echo "$prog killed"
	fi
    done
elif [ $REMOVE -eq 0 ]; then
    mkdir -p $BINDIR
    install -CDv $PROG -t $BINDIR

    if [ $NO_DESKTOP -eq 0 ]; then
	mkdir -p $APPDIR
	tmp=$(mktemp)
	sed "s#^Exec=.*#Exec=$BINDIR/$PROG#" $PROG.desktop >$tmp
	if ! cmp -s $tmp "$APPDIR/$PROG.desktop"; then
	    echo "$PROG.desktop -> $APPDIR/$PROG.desktop"
	    mv $tmp $APPDIR/$PROG.desktop
	    chmod 644 $APPDIR/$PROG.desktop
	fi
	rm -f $tmp

	mkdir -p $AUTDIR
	if [ ! -L $AUTDIR/$PROG.desktop ]; then
	    echo "$APPDIR/$PROG.desktop -> $AUTDIR/$PROG.desktop"
	    ln -sf $APPDIR/$PROG.desktop $AUTDIR/
	fi
    fi

    if [ ! -f $HOME/.config/${PROG}.conf -o $FORCE -ne 0  ]; then
	install -Cv -m 600 ${PROG}.conf -T $HOME/.config/${PROG}.conf
    fi
fi

if [ $REMOVE -ne 0 ]; then
    if clean $BINDIR/$PROG; then
	rmdir --ignore-fail-on-non-empty $BINDIR
    fi

    clean $APPDIR/$PROG.desktop
    clean $AUTDIR/$PROG.desktop
    if [ $FORCE -ne 0  ]; then
	clean $HOME/.config/${PROG}.conf
    fi
fi

if [ -x /usr/bin/update-desktop-database ]; then
    /usr/bin/update-desktop-database -q
fi

if [ $START -ne 0 -a -f "$APPDIR/$PROG.desktop" ]; then
    if gtk-launch "$PROG"; then
	echo "$PROG started"
    fi
fi

exit 0
