#!/bin/bash

# Set the directory path
MOVIE_DIR="/mnt/vault2/Downloaded/Movies"
TV_DIR="/mnt/vault2/Downloaded/Shows"

# Set the number of days
DAYS=3

# Find and delete files older than DAYS
find "$MOVIE_DIR" -type f -mtime +$DAYS -delete
find "$TV_DIR" -type f -mtime +$DAYS -delete

# Optionally, to delete empty directories as well:
find "$MOVIE_DIR" -type d -empty -delete
find "$TV_DIR" -type d -empty -delete