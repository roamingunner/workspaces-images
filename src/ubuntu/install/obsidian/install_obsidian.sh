#!/usr/bin/env bash
OBSIDIAN_VERSION=0.15.9
set -ex
mkdir -p /opt/obsidian
cd /opt/obsidian
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/Obsidian-${OBSIDIAN_VERSION}.AppImage -O Obsidian-${OBSIDIAN_VERSION}.AppImage
chmod +x Obsidian-${OBSIDIAN_VERSION}.AppImage
./Obsidian-${OBSIDIAN_VERSION}.AppImage --appimage-extract
rm Obsidian-${OBSIDIAN_VERSION}.AppImage
chown -R 1000:1000 /opt/obsidian

cat >/opt/obsidian/squashfs-root/launcher <<EOF
#!/usr/bin/env bash
export APPDIR=/opt/obsidian/squashfs-root/
/opt/obsidian/squashfs-root/AppRun --no-sandbox "$@"
EOF

chmod +x /opt/obsidian/squashfs-root/launcher

sed -i 's@^Exec=.*@Exec=/opt/obsidian/squashfs-root/launcher@g' /opt/obsidian/squashfs-root/obsidian.desktop
sed -i 's@^Icon=.*@Icon=/opt/obsidian/squashfs-root/obsidian.png@g' /opt/obsidian/squashfs-root/obsidian.desktop
cp /opt/obsidian/squashfs-root/obsidian.desktop  $HOME/Desktop
cp /opt/obsidian/squashfs-root/obsidian.desktop /usr/share/applications/
chmod +x $HOME/Desktop/obsidian.desktop
chmod +x /usr/share/applications/obsidian.desktop
