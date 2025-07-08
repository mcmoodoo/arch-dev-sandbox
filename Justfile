build:
    podman build -t arch-dev:latest .

run:
    podman run --rm -itd --net=host --name arch-dev --userns=keep-id -v "$(pwd)":/home/developer/workspace:Z -w /home/developer/workspace arch-dev:latest bash

connect:
    podman exec -it arch-dev bash

stop:
    podman stop arch-dev

build-tag-with-commit:
    podman build -t arch-dev:$(git rev-parse --short HEAD) .


