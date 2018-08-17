## Minimal Distro Install

get minimal cd from here: https://help.ubuntu.com/community/Installation/MinimalCD
http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/mini.iso

copy to usb, boot and install, create boxadmin user, reboot

## installing kiosk

reboot, login to boxadmin

refering to https://willhaley.com/blog/debian-fullscreen-gui-kiosk/

become root
```
sudo bash
```

update package repos indexes and install preqs
```
apt-get update
apt-get install \
    sudo \
    xorg \
    xdg-utils \
    openbox \
    lightdm
```

downloading and install google chrom from official site
```
wget blah
dpkg -i blah
```

adding kiosk user
```
useradd -m kiosk-user
```

edit lightdm config /etc/lightdm/lightdm.conf
```
[SeatDefaults]
autologin-user=kiosk-user
user-session=openbox
```

Create the openbox config directory for kiosk-user if it does not exist.
```
mkdir -p $HOME/.config/openbox
```

Create a script at $HOME/.config/openbox/autostart for the kiosk-user. This script will be run at login.
```
#!/bin/bash

google-chrome-stable \
    --no-first-run \
    --disable \
    --disable-translate \
    --disable-infobars \
    --disable-suggestions-service \
    --disable-save-password-bubble \
    --start-maximized \
    --kiosk "http://www.google.com" &
```

The & at the end is required for every command in the autostart script.

Reboot, and you should see the machine automatically login and run chrome in kiosk mode.
