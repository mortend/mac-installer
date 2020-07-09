#!/bin/bash
set -e

# Config
export PATH=/usr/local/bin:$PATH
export TGZ=/tmp/fuse-x-studio-mac.tgz
export DST=`npm prefix -g`/lib/node_modules/@fuse-x/studio-mac
export BIN=$DST/bin/Release
export APP=$BIN/fuse\ X.app
export EXE=$BIN/fuse.exe

# Install
npm install -g -f "$TGZ"
mono "$EXE" --version
mono "$EXE" kill-all

# Copy app
cp -R "$APP" /Applications/
echo "require \"$DST/.unoconfig\"\n" \
	> /Applications/fuse\ X.app/Contents/.unoconfig
