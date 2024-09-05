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
- `/var/lib/sonarr/config`: Sonarr configuration
- `/var/lib/bazarr/config`: Bazarr configuration
- `/var/lib/ersatztv/config`: ersatztv configuration

You may need to create these folders and ensure the correct permissions are set.

## Environment Variables

The following environment variables are used to configure the various services:

- `PLEX_CLAIM`: The claim for the Plex server
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
- `UMASK`: The umask for the user running the containers
- `TZ`: The timezone for the containers
- `DOMAIN`: The domain name for the server

## Starting the Services on Boot

To start the services on boot, first modify the `media-server.service` file to set the correct paths to your repo folder. Then copy the file to `/etc/systemd/system/` and run `sudo systemctl enable media-server.service`.

### Docker

You will need to install `docker` and `docker-compose` on your system.

To have docker start on boot, you should add your user to the `docker` group and enable the docker
service.

```bash
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable docker
```

## Misc

### Volume Mounts

In this setup it is assumed that you have 2 volumes mounted on your host machine. To have these mount automatically on startup, you can add the following to your `/etc/fstab` file:

```txt
UUID=b1b817e3-0a07-36fd-9388-5956ab2fb34f /mnt/vault2 hfsplus force,rw 0 1
UUID=2151fd36-4286-30e1-be8f-cf128abe7f4d /mnt/vault1 hfsplus force,rw 0 1
```

Just replace the UUIDs with your own. You can find the UUIDs of your volumes by running `lsblk`.

### Config Backup

(Note: There is a bash alias available for this by running `git clone https://gist.github.com/a10b4659279eb5eb72c5eeb71a111fbb.git ~/a10b4659279eb5eb72c5eeb71a111fbb && cp ~/a10b4659279eb5eb72c5eeb71a111fbb/.bash_aliases ~/.bash_aliases && source ~/.bash_aliases)

To backup the config files, you can run the following command:

```bash
sudo rsync -av /var/lib/transmission-daemon/.config/transmission-daemon /mnt/vault1/Config/transmission-daemon
sudo rsync -av /var/lib/plexmediaserver /mnt/vault1/Config/plexmediaserver
sudo rsync -av /var/lib/jellyfin/config /mnt/vault1/Config/jellyfin
sudo rsync -av /var/lib/jellyfin/cache /mnt/vault1/Config/jellyfin
sudo rsync -av /var/lib/jellyseerr/config /mnt/vault1/Config/jellyseerr
sudo rsync -av /var/lib/radarr/config /mnt/vault1/Config/radarr
sudo rsync -av /var/lib/prowlarr/config /mnt/vault1/Config/prowlarr
sudo rsync -av /var/lib/sonarr/config /mnt/vault1/Config/sonarr
sudo rsync -av /var/lib/bazarr/config /mnt/vault1/Config/bazarr
sudo rsync -av /var/lib/ersatztv/config /mnt/vault1/Config/ersatztv
```

#### Config Restore

To restore the config files, you can run the following command:

```bash
sudo rsync -av /mnt/vault1/Config/transmission-daemon /var/lib/transmission-daemon/.config/transmission-daemon
sudo rsync -av /mnt/vault1/Config/plexmediaserver /var/lib/plexmediaserver
sudo rsync -av /mnt/vault1/Config/jellyfin /var/lib/jellyfin
sudo rsync -av /mnt/vault1/Config/jellyseerr /var/lib/jellyseerr
sudo rsync -av /mnt/vault1/Config/radarr /var/lib/radarr
sudo rsync -av /mnt/vault1/Config/prowlarr /var/lib/prowlarr
sudo rsync -av /mnt/vault1/Config/sonarr /var/lib/sonarr
sudo rsync -av /mnt/vault1/Config/bazarr /var/lib/bazarr
sudo rsync -av /mnt/vault1/Config/ersatztv /var/lib/ersatztv
```

### Cleanup Old Downloads

To cleanup old downloads, you can run the following command:

```bash
./cleanup_old_downloads.sh
```

This will delete files older than 3 days in the `/mnt/vault2/Downloaded/Movies` and `/mnt/vault2/Downloaded/Shows` directories.

You may have to add the execute permission to the script by running `chmod +x cleanup_old_downloads.sh`.

You can also add this to your crontab to run at a specific time.

```bash
crontab -e
```

```bash
0 3 * * * /path/to/cleanup_old_downloads.sh
```
