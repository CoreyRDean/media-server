# Dockerized Media Server

## Config Folders

The following folders are used to store the configuration for the various services:

- `/var/lib/transmission-daemon/.config/transmission-daemon`: Transmission configuration
- `/var/lib/plexmediaserver`: Plex configuration
- `/var/lib/jellyfin/config`: Jellyfin configuration
- `/var/lib/jellyfin/cache`: Jellyfin cache
- `/var/lib/jellyseerr/config`: Jellyseerr configuration
- `/var/lib/radarr/config`: Radarr configuration
- `/var/lib/prowlarr/config`: Prowlarr configuration

You may need to create these folders and ensure the correct permissions are set.

## Environment Variables

The following environment variables are used to configure the various services:

- `OPENVPN_PROVIDER`: The name of the VPN provider
- `OPENVPN_USERNAME`: The username for the VPN
- `OPENVPN_PASSWORD`: The password for the VPN
- `OPENVPN_CONFIG`: The configuration for the VPN
- `TRANSMISSION_RPC_USERNAME`: The username for the Transmission RPC
- `TRANSMISSION_RPC_PASSWORD`: The password for the Transmission RPC
- `TRANSMISSION_DOWNLOAD_DIR`: The directory for completed downloads
- `TRANSMISSION_INCOMPLETE_DIR`: The directory for incomplete downloads
- `TRANSMISSION_WATCH_DIR`: The directory for watch downloads
- `PUID`: The user ID for the user running the containers
- `PGID`: The group ID for the group running the containers
- `TZ`: The timezone for the containers

## Starting the Services on Boot

To start the services on boot, first modify the `media-server.service` file to set the correct paths to your repo folder. Then copy the file to `/etc/systemd/system/` and run `sudo systemctl enable media-server.service`.

## Misc

### Volume Mounts

In this setup it is assumed that you have 2 volumes mounted on your host machine. To have these mount automatically on startup, you can add the following to your `/etc/fstab` file:

```txt
UUID=b1b817e3-0a07-36fd-9388-5956ab2fb34f /mnt/vault2 hfsplus force,rw 0 1
UUID=2151fd36-4286-30e1-be8f-cf128abe7f4d /mnt/vault1 hfsplus force,rw 0 1
```

Just replace the UUIDs with your own. You can find the UUIDs of your volumes by running `lsblk`.
