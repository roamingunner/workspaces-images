#!/usr/bin/env bash
VNOTE_VERSION=v3.13.0
set -ex
mkdir -p /opt/vnote
cd /opt/vnote
wget https://github.com/vnotex/vnote/releases/download/${VNOTE_VERSION}/vnote-linux-x64_${VNOTE_VERSION}.zip -O vnote-linux-x64_${VNOTE_VERSION}.zip 
unzip -x vnote-linux-x64_${VNOTE_VERSION}.zip 
chmod +x vnote-linux-x64_${VNOTE_VERSION}.AppImage
vnote-linux-x64_${VNOTE_VERSION}.AppImage --appimage-extract
rm vnote-linux-x64_${VNOTE_VERSION}.AppImage vnote-linux-x64_${VNOTE_VERSION}.zip 
chown -R 1000:1000 /opt/vnote

cat >/opt/vnote/squashfs-root/launcher <<EOL
#!/usr/bin/env bash
export APPDIR=/opt/vnote/squashfs-root/
/opt/vnote/squashfs-root/AppRun --no-sandbox "$@"
EOL

chmod +x /opt/vnote/squashfs-root/launcher

sed -i 's@^Exec=.*@Exec=/opt/vnote/squashfs-root/launcher@g' /opt/vnote/squashfs-root/vnote.desktop
sed -i 's@^Icon=.*@Icon=/opt/vnote/squashfs-root/vnote.png@g' /opt/vnote/squashfs-root/vnote.desktop
cp /opt/vnote/squashfs-root/vnote.desktop  $HOME/Desktop
cp /opt/vnote/squashfs-root/vnote.desktop /usr/share/applications/
chmod +x $HOME/Desktop/vnote.desktop
chmod +x /usr/share/applications/vnote.desktop