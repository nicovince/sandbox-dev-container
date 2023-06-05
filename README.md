# Sandbox Dev Container
Docker container with my custom environment for sandbox testing

## Pull and run container from ghcr.io
```
docker run --rm -it -h SANDBOX ghcr.io/nicovince/sandbox-dev-container:main
```

## Build container
```
docker build -t sandbox-dev .
```

## Run container

```
docker run --rm -it -h SANDBOX sandbox-dev
```
