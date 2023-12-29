#!/bin/bash
#set -e

git clone https://github.com/robiningelbrecht/strava-activities-template.git --depth 1

# Copy all files from template to this repo.
mv -f strava-activities-template/.gitignore .gitignore
mv -f strava-activities-template/bin/console bin/console
mv -f strava-activities-template/bin/doctrine-migrations bin/doctrine-migrations
rm -Rf config/* && rmdir config 
mkdir config && mv -f strava-activities-template/config/* config/
rm -Rf migrations/* && rmdir migrations 
mkdir migrations && mv -f strava-activities-template/migrations/* migrations/
rm -Rf public/* && rmdir public 
mkdir public && mv -f strava-activities-template/public/* public/
rm -Rf src/* && rmdir src 
mkdir src && mv -f strava-activities-template/src/* src/
rm -Rf templates/* && rmdir templates 
mkdir templates && mv -f strava-activities-template/templates/* templates/
## Build asset files
rm -Rf build/html/echarts/* && rmdir build/html/echarts 
mkdir build/html/echarts && mv -f strava-activities-template/build/html/echarts/* build/html/echarts/
rm -Rf build/html/flowbite/* && rmdir build/html/flowbite 
mkdir build/html/flowbite && mv -f strava-activities-template/build/html/flowbite/* build/html/flowbite/
rm -Rf build/html/leaflet/* && rmdir build/html/leaflet 
mkdir -p build/html/leaflet && rm -Rf build/html/leaflet/* && mv -f strava-activities-template/build/html/leaflet/* build/html/leaflet/
mv -f strava-activities-template/build/html/dark-mode-toggle.js build/html/dark-mode-toggle.js
mv -f strava-activities-template/build/html/favicon.ico build/html/favicon.ico
mv -f strava-activities-template/build/html/placeholder.webp build/html/placeholder.webp
mv -f strava-activities-template/build/html/lazyload.min.js build/html/lazyload.min.js
mv -f strava-activities-template/build/html/router.js build/html/router.js
mv -f strava-activities-template/build/html/searchable.js build/html/searchable.js
mv -f strava-activities-template/build/html/sortable.min.js build/html/sortable.min.js

mv -f strava-activities-template/tailwind.config.js tailwind.config.js
mv -f strava-activities-template/echart.js echart.js
mv -f strava-activities-template/composer.json composer.json
mv -f strava-activities-template/composer.lock composer.lock
mv -f strava-activities-template/package.json package.json
mv -f strava-activities-template/package-lock.json package-lock.json
mv -f strava-activities-template/vercel.json vercel.json

# Make sure database and migration directories exist
mkdir -p migrations

# Delete install files
rm -Rf files/install
rm -Rf files/maps
# Delete test suite
rm -Rf tests
rm -Rf config/container_test.php
# Delete template again.
rm -Rf strava-activities-template

#make .env
rm .env
echo ENVIRONMENT=dev >> .env
echo DISPLAY_ERROR_DETAILS=1 >> .env
echo LOG_ERRORS=0 >> .env
echo LOG_ERROR_DETAILS=0 >> .env
echo DATABASE_NAME="database/db.strava" >> .env
echo REPOSITORY_NAME=localhost >> .env  #todo potential problem
#should be done through docker run echo STRAVA_CLIENT_ID=${{ secrets.STRAVA_CLIENT_ID }} >> .env
#should be done through docker run echo STRAVA_CLIENT_SECRET=${{ secrets.STRAVA_CLIENT_SECRET }} >> .env
#should be done through docker run echo STRAVA_REFRESH_TOKEN=${{ secrets.STRAVA_REFRESH_TOKEN }} >> .env

composer install --prefer-dist

# Run migrations.
./vendor/bin/doctrine-migrations migrate --no-interaction

# Exit when only template update.
if [ "$1" == "--only-template" ]; then
  exit 0;
fi

# Update strava stats.
#bin/console app:strava:import-data
#bin/console app:strava:build-files

# Vacuum database
#bin/console app:strava:vacuum

# Generate charts
npm ci
node echart.js

# Push changes
#git add .
#git status
#git diff --staged --quiet || git commit -m"Updated strava activities"
#git push