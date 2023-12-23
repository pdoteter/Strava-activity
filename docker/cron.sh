#!/usr/bin/bash
#set -e

# Run migrations.
./vendor/bin/doctrine-migrations migrate --no-interaction

# Exit when only template update.
if [ "$1" == "--only-template" ]; then
  exit 0;
fi

# Update strava stats.
bin/console app:strava:import-data
bin/console app:strava:build-files

# Vacuum database
bin/console app:strava:vacuum

# Generate charts
npm ci
node echart.js

# Push changes
#git add .
#git status
#git diff --staged --quiet || git commit -m"Updated strava activities"
#git push