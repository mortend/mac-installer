#!/bin/sh
set -e
cd "`dirname "$0"`"

# Clean up old stuff
rm -rf pkgs *.pkg

# Set app permissions
ls -d1 root/Applications/*.app root/Applications/fuse\ X.app/Contents/*.app | while read app; do
    echo Setting permission for "$app"
    chmod -Rf +x "$app/Contents/MacOS/"
done

if ! [ "$SIGN" = "0" ]; then
	codesign --force --deep -s "Developer ID Application: Outracks Technologies AS" root/Applications/fuse\ X.app
fi

# `uno` wrapper
mkdir -p root/usr/local/bin

cat <<'EOF' > root/usr/local/bin/uno
#!/bin/sh
export FONTCONFIG_PATH=/Applications/fuse\ X.app/Contents/Mono/etc/fonts
exec /Applications/fuse\ X.app/Contents/Mono/bin/mono --gc=sgen /Applications/fuse\ X.app/Contents/Uno/uno.exe "$@"
EOF

cat <<'EOF' > root/usr/local/bin/fuse
#!/bin/sh
/Applications/fuse\ X.app/Contents/MacOS/fuse\ X "$@"
EOF

# Remove all .DS_Store files
find root -name ".DS_Store" -depth -exec rm {} \;

# Make sure scripts are executable
chmod +x scripts/*
chmod +x root/usr/local/bin/*

mkdir -p pkgs
pkgbuild --root root \
    --component-plist components.plist \
    --identifier kr.fuseapps.fuse \
    --version $VERSION \
    --ownership recommended \
    --scripts scripts \
    pkgs/Fuse.pkg

UNSIGNED="Fuse-unsigned.pkg"
SIGNED="Fuse.pkg"

productbuild --distribution Distribution.xml \
    --package-path pkgs \
    --resources resources/ \
    $UNSIGNED

if [ "$SIGN" = "0" ]; then
    exit 0
fi

productsign --sign "Developer ID Installer: Outracks Technologies AS" \
    $UNSIGNED $SIGNED

spctl --assess --type install -v \
    $SIGNED
