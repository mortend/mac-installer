#!/bin/bash
set -e
cd "`dirname "$0"`"

# Clean up old stuff
rm -rf pkgs *.pkg

# Remove all .DS_Store files
find root -name ".DS_Store" -depth -exec rm {} \;

# Make sure scripts are executable
chmod +x scripts/* *.sh

# Include installer scripts
cp check-system.sh root/tmp/
cp install-fuse.sh root/tmp/
cp launch-fuse.sh root/tmp/
cp *.js root/tmp/

mkdir -p pkgs
pkgbuild --root root \
    --identifier kr.fuseapps.studio \
    --version $VERSION \
    --ownership recommended \
    --scripts scripts \
    pkgs/fuse-studio.pkg

UNSIGNED="fuse-unsigned.pkg"
SIGNED="fuse-signed.pkg"

productbuild --distribution Distribution.xml \
    --package-path pkgs \
    --resources resources/ \
    $UNSIGNED

if [ "$SIGN" != 1 ]; then
    exit 0
fi

productsign --sign "Developer ID Installer: Outracks Technologies AS" \
    $UNSIGNED $SIGNED

spctl --assess --type install -v \
    $SIGNED
