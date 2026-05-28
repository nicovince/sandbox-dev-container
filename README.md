# Sandbox Dev Container
Docker container with my custom environment for sandbox testing

## Pull and run container from ghcr.io
```bash
docker run --rm -it -h SANDBOX ghcr.io/nicovince/sandbox-dev-container:main-26.04
```

## Build container
```bash
docker build -t sandbox-dev . -f Dockerfile.26.04
```

## Run container

```bash
docker run --rm -it -h SANDBOX sandbox-dev
```

## docker-compose

The `docker-compose.yml` mounts a host project directory into the container and shares the host opencode configuration using docker volume.

### Start container

- Set the PRJNAME to set the hostname displayed in the shell prompt
- Set `PRJ_DIR` to the directory you want to mount as `/workspace` inside the container
then start:

```bash
PRJNAME=foo PRJ_DIR=/path/to/your/project docker compose up -d
```

Or export it first:
```bash
export PRJNAME=foo
export PRJ_DIR=/path/to/your/project
docker compose up -d
```

### Open a shell in the running container

```bash
docker compose exec dev bash
```
or
```bash
docker exec -it ${PRJ_NAME} bash
```

### Stop container

```
docker compose down
```
