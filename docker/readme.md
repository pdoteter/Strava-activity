Docker container should be build in the root directory of this project like this:

```powershell
docker build -f docker/1.0/Dockerfile -t strava-activity/1.0 .
```

Usage of the created docker

The database folder should at least be mapped to a volume or local drive, so that updates don't delete the data

A docker componse file is created, run it like this:

```powershell
docker compose -f .\docker\docker-compose.yml --env-file .\docker\.env.private -p strava up -d
```

