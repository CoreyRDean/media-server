#!/bin/bash

# Set the directory path
MOVIE_DIR="/mnt/vault2/Downloaded/Movies"
TV_DIR="/mnt/vault2/Downloaded/Shows"
PHOTO_CACHE_DIR="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Cache/PhotoTranscoder"

# Set the number of days
DAYS=3

# Find and delete files older than DAYS
find "$MOVIE_DIR" -type f -mtime +$DAYS -delete
find "$TV_DIR" -type f -mtime +$DAYS -delete
find "$PHOTO_CACHE_DIR" -name "*.jpg" -type f -mtime +$DAYS -delete

# Delete empty subdirectories, but not the main directories
find "$MOVIE_DIR" -mindepth 1 -type d -empty -delete
find "$TV_DIR" -mindepth 1 -type d -empty -delete
find "$PHOTO_CACHE_DIR" -mindepth 1 -type d -empty -delete
