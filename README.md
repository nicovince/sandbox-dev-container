# Sandbox Dev Container
Docker container with my custom environment for sandbox testing

## Pull and run container from ghcr.io
```
docker run --rm -it -h SANDBOX ghcr.io/nicovince/sandbox-dev-container:main-22.04
```

## Build container
```
docker build -t sandbox-dev . -f Dockerfile.22.04
```

## Run container

```
docker run --rm -it -h SANDBOX sandbox-dev
```
