#!/bin/bash
set -e

# Mono and NPM
export PATH=/usr/local/bin:$PATH
export PATH=/Library/Frameworks/Mono.framework/Versions/Current/Commands:$PATH

# Config
TGZ=/tmp/fuse-x-studio-mac.tgz
PREFIX=/usr/local
DST=$PREFIX/lib/node_modules/@fuse-x/studio-mac
BIN=$DST/bin/Release
APP=$BIN/fuse\ X.app
FUSE=$PREFIX/bin/fuse
UNO=$PREFIX/bin/uno

# Override tarball
if [ -n "$1" ]; then
    TGZ=$1
fi

# Debug
echo USER:  $USER
echo HOME:  $HOME
echo TGZ:   $TGZ
echo DST:   $DST
echo FUSE:  $FUSE
echo UNO:   $UNO

# Install
rm -rf ~/.dotnet-run
npm install -g -f "$TGZ" --prefix "$PREFIX"
"$FUSE" kill-all

# Copy app
# cp -R "$APP" /Applications/
# echo "require \"$DST/.unoconfig\"\n" \
# 	> /Applications/fuse\ X.app/Contents/.unoconfig

# Symlink app (for now)
ln -sf "$APP" /Applications/

# Copy uri-handler app
cp -R "$BIN"/fuse-uri.app /Applications/

# Warm-up
"$UNO" build "$DST/empty"
