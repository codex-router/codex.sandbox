# codex.sandbox

Build and run Piston (code execution engine) in Docker.

The Docker image also installs `codexc` from the latest release of `codex-router/codex.compiler` during build.

## Prerequisites

- Docker
- Linux host with cgroup v2 enabled

## Build image

```bash
./build.sh
```

## Run container

```bash
docker run --rm \
	--privileged \
	-p 2000:2000 \
	-v "$(pwd)/codex-sandbox/packages:/piston/packages" \
	--name codex-sandbox \
	craftslab/codex-sandbox:latest
```

On startup, the container seeds preinstalled runtimes into `/piston/packages` when this mounted directory is empty.
Currently, the image preinstalls `bash` runtime and also backfills missing `bash` into `/piston/packages` even when that mounted directory already contains other runtimes.

## Run with Docker Compose

```bash
docker compose -f docker-compose-codex.sandbox.yaml up -d
```

## Stop with Docker Compose

```bash
docker compose -f docker-compose-codex.sandbox.yaml down
```

## Quick test

```bash
bash test.sh
```

## Example usage

```bash
bash example.sh
```

The API endpoint is available at `http://localhost:2000/api/v2/runtimes`.
