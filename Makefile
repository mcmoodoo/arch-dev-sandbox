build-latest:
	podman build -t arch-dev:latest .

build-tag-with-commit:
	podman build -t arch-dev:$$(git rev-parse --short HEAD) .

spin-up:
	podman run -it -d --rm --name arch-dev --hostname arch-dev --network host -v $$(pwd)/workspace:/workspace arch-dev

connect:
	podman exec -it arch-dev /bin/bash
