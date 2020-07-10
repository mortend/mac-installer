#!/bin/bash
set -e

# Config
export PATH=/usr/local/bin:$PATH
export TGZ=/tmp/fuse-x-studio-mac.tgz
export PREFIX=`npm prefix -g`
export DST=$PREFIX/lib/node_modules/@fuse-x/studio-mac
export BIN=$DST/bin/Release
export APP=$BIN/fuse\ X.app
export FUSE=$PREFIX/bin/fuse
export UNO=$PREFIX/bin/uno

# Debug
echo USER:  $USER
echo HOME:  $HOME
echo DST:   $DST
echo FUSE:  $FUSE
echo UNO:   $UNO

# Install
rm -rf ~/.dotnet-run
npm install -g -f "$TGZ"
"$FUSE" kill-all

# Copy app
# cp -R "$APP" /Applications/
# echo "require \"$DST/.unoconfig\"\n" \
# 	> /Applications/fuse\ X.app/Contents/.unoconfig

# Symlink app (for now)
ln -sf "$APP" /Applications/

# Warm-up
"$UNO" build "$DST/empty"
