# codex.sandbox

Build and run Piston (code execution engine) in Docker.

## Prerequisites

- Docker
- Linux host with cgroup v2 enabled

## Build image

```bash
docker build -f Dockerfile_codex.sandbox -t craftslab/codex-sandbox:latest .
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

## Run with Docker Compose

```bash
docker compose -f docker-compose-codex.sandbox.yaml up -d
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
