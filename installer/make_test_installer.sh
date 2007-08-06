#!/bin/sh

# Author: Tobi Vollebregt
# Initial version copied from make_test_installer.bat

# Quit on error.
set -e

# Find correct working directory.
# (Compatible with SConstruct, which is in trunk root)

while [ ! -d installer ]; do
        if [ "$PWD" = "/" ]; then
                echo "Error: Could not find installer directory."
                echo "Make sure to run this script from a directory below your checkout directory."
                exit 1
        fi
        cd ..
done

# Got a revision argument?

if [ -z "$1" ]; then
	REVISION=`svnversion | grep -o -E '[0-9]+'`
else
	REVISION=$1
fi
echo "Creating installers for revision $REVISION"

# Figure out whether this is a test build or a release build,
# and build the correct full and updating installers.
# The grep regex matches the ones used in buildbot.

if grep -o -E '0\.[0-9]{2,2}[b.][0-9]\+(svn[0-9]+)?' rts/Game/GameVersion.h >/dev/null; then
	echo "Creating test installer"
	makensis -V3 -DTEST_BUILD -DREVISION=$REVISION installer/taspring.nsi

	echo "Creating updating test installer"
	makensis -V3 -DSP_UPDATE -DTEST_BUILD -DREVISION=$REVISION installer/taspring.nsi
else
	echo "Creating installer"
	makensis -V3 installer/taspring.nsi

	echo "Creating updating installer"
	makensis -V3 -DSP_UPDATE installer/taspring.nsi
fi
