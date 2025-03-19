build:
	podman build -t arch-dev:latest .

spin-up:
	podman run -it -d --rm --name arch-dev --hostname arch-dev -v $$(pwd)/workspace:/workspace arch-dev

connect:
	podman exec -it arch-dev /bin/bash
