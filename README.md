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

The following environment variables are used to configure the various services. These should be set in your `.env` file:

### General Configuration
- `DOMAIN`: The domain name for the server
- `TZ`: The timezone for the containers (default: America/Chicago)
- `PUID`: The user ID for the user running the containers (default: 1000)
- `PGID`: The group ID for the group running the containers (default: 1000)
- `UMASK`: The umask for the user running the containers (default: 002)

### OpenVPN Configuration
- `OPENVPN_PROVIDER`: The name of the VPN provider
- `OPENVPN_USERNAME`: The username for the VPN
- `OPENVPN_PASSWORD`: The password for the VPN
- `OPENVPN_CONFIG`: The configuration for the VPN

### Transmission Configuration
- `TRANSMISSION_RPC_USERNAME`: The username for the Transmission RPC
- `TRANSMISSION_RPC_PASSWORD`: The password for the Transmission RPC
- `TRANSMISSION_DOWNLOAD_DIR`: The directory for completed downloads (default: /mnt/vault2/Downloaded)
- `TRANSMISSION_INCOMPLETE_DIR`: The directory for incomplete downloads (default: /incomplete)
- `TRANSMISSION_WATCH_DIR`: The directory for watch downloads (default: /watch)

### Plex Configuration
- `PLEX_CLAIM`: The claim token for the Plex server

### Resource Limits
Each service has CPU and memory limit variables. For example:
- `TRAEFIK_CPU_LIMIT`: CPU limit for Traefik (default: 0.25)
- `TRAEFIK_MEMORY_LIMIT`: Memory limit for Traefik (default: 512M)

Similar variables exist for all other services (Plex, Jellyfin, Radarr, Sonarr, etc.).

### Service-specific Configuration
Each service has its own port variable. For example:
- `JELLYFIN_PORT`: The port for Jellyfin (default: 8096)
- `RADARR_PORT`: The port for Radarr (default: 7878)

Similar variables exist for all other services.

### Directory Paths
Each service has its own configuration directory variable. For example:
- `PLEX_CONFIG_DIR`: The configuration directory for Plex (default: /var/lib/plexmediaserver)
- `JELLYFIN_CONFIG_DIR`: The configuration directory for Jellyfin (default: /var/lib/jellyfin/config)

Similar variables exist for all other services.

### Media Directories
- `MEDIA_DIR_1`: The first media directory (default: /mnt/vault1)
- `MEDIA_DIR_2`: The second media directory (default: /mnt/vault2)
- `PLEX_LOGS_DIR`: The directory for Plex logs
- `AUTO_M4B_DOWNLOADED_DIR`: The directory for downloaded audiobooks
- `AUTO_M4B_TEMP_DIR`: The temporary directory for Auto-M4B
- `AUTO_M4B_UNTAGGED_DIR`: The directory for untagged audiobooks
- `AUDIOBOOKSHELF_AUDIOBOOKS_DIR`: The directory for audiobooks in Audiobookshelf

### Additional Configuration
- `AUTO_M4B_CPU_CORES`: The number of CPU cores for Auto-M4B (default: 2)
- `AUTO_M4B_SLEEPTIME`: The sleep time for Auto-M4B (default: 5m)
- `AUTO_M4B_MAKE_BACKUP`: Whether to make backups in Auto-M4B (default: N)

Please refer to the `.env.example` file for a complete list of all available environment variables and their default values.

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
sudo rsync -av --delete /var/lib/transmission-daemon/.config/transmission-daemon/ /mnt/vault1/Config/transmission-daemon/
sudo rsync -av --delete /var/lib/plexmediaserver/ /mnt/vault1/Config/plexmediaserver/
sudo rsync -av --delete /var/lib/jellyfin/ /mnt/vault1/Config/jellyfin/
sudo rsync -av --delete /var/lib/jellyseerr/ /mnt/vault1/Config/jellyseerr/
sudo rsync -av --delete /var/lib/radarr/ /mnt/vault1/Config/radarr/
sudo rsync -av --delete /var/lib/prowlarr/ /mnt/vault1/Config/prowlarr/
sudo rsync -av --delete /var/lib/sonarr/ /mnt/vault1/Config/sonarr/
sudo rsync -av --delete /var/lib/bazarr/ /mnt/vault1/Config/bazarr/
sudo rsync -av --delete /var/lib/ersatztv/ /mnt/vault1/Config/ersatztv/
```

#### Config Restore

To restore the config files, you can run the following command:

```bash
sudo rsync -av /mnt/vault1/Config/transmission-daemon/ /var/lib/transmission-daemon/.config/transmission-daemon/
sudo rsync -av /mnt/vault1/Config/plexmediaserver/ /var/lib/plexmediaserver/
sudo rsync -av /mnt/vault1/Config/jellyfin/ /var/lib/jellyfin/
sudo rsync -av /mnt/vault1/Config/jellyseerr/ /var/lib/jellyseerr/
sudo rsync -av /mnt/vault1/Config/radarr/ /var/lib/radarr/
sudo rsync -av /mnt/vault1/Config/prowlarr/ /var/lib/prowlarr/
sudo rsync -av /mnt/vault1/Config/sonarr/ /var/lib/sonarr/
sudo rsync -av /mnt/vault1/Config/bazarr/ /var/lib/bazarr/
sudo rsync -av /mnt/vault1/Config/ersatztv/ /var/lib/ersatztv/
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

## Docker Compose Profiles

This project uses Docker Compose profiles to allow for flexible deployment of services. Here's how to use them:

### Available Profiles

- `core`: Essential services that should always run
- `media`: Media management and streaming services
- `download`: Download-related services
- `web`: Web-based interfaces and proxies
- `books`: Book-related services
- `maintenance`: Maintenance services
- `monitoring`: Monitoring services
- `plex`: Plex-specific services
- `jellyfin`: Jellyfin-specific services
- `all-media`: Both Plex and Jellyfin services
- `all-plex`: All services except Jellyfin
- `all-jellyfin`: All services except Plex and Plex-specific services

### Using Profiles

To start services using specific profiles, use the `--profile` flag with `docker-compose up`. You can use multiple profiles in a single command. Here are some examples:

1. Start core services only:

   ```bash
   docker-compose --profile core up -d
   ```

2. Start core and media services:

   ```bash
   docker-compose --profile core --profile media up -d
   ```

3. Start everything with Plex (no Jellyfin):

   ```bash
   docker-compose --profile all-plex up -d
   ```

4. Start everything with Jellyfin (no Plex):

   ```bash
   docker-compose --profile all-jellyfin up -d
   ```

5. Start core services with Plex:

   ```bash
   docker-compose --profile core --profile plex up -d
   ```

6. Start core services with Jellyfin:

   ```bash
   docker-compose --profile core --profile jellyfin up -d
   ```

7. Start all services (including both Plex and Jellyfin):

   ```bash
   docker-compose --profile all-media up -d
   ```

### Stopping Services

To stop services, you can use the same profile flags with the `down` command.
