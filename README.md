# Arch Linux Development Container

A multi-stage Docker/Podman container for development work with Arch Linux, featuring optimized builds and a comprehensive set of development tools.

## Features

- **Multi-stage build** for minimal final image size
- **Arch Linux base** with latest packages
- **Rust development environment** with popular CLI tools
- **Development tools** including Git, network utilities, and text editors
- **Starship terminal** with modern shell experience
- **Non-root user** (UID 1000) for security and permission compatibility

## Quick Start

### Build the Container
```bash
# Build latest version
make build-latest

# Build with git commit tag
make build-tag-with-commit
```

### Run the Container
```bash
# Start container in background
make spin-up

# Connect to running container
make connect
```

## Manual Commands

### Building
```bash
# Build container
podman build -t arch-dev:latest .

# Build with specific tag
podman build -t arch-dev:$(git rev-parse --short HEAD) .
```

### Running
```bash
# Run container with workspace volume
podman run -it -d --rm --name arch-dev --hostname arch-dev -v $(pwd)/workspace:/workspace arch-dev

# Execute bash in running container
podman exec -it arch-dev /bin/bash
```

## Validation

Test the container configuration:
```bash
./test_dockerfile.sh
```

This script validates:
- File presence and structure
- Dockerfile syntax (with hadolint if available)
- Multi-stage build optimization
- Cache cleanup strategies
- User permission configuration
- Path and environment setup

## Container Structure

### Stage 1: Builder
- Installs build dependencies and Rust toolchain
- Compiles and installs Rust CLI tools
- Cleans up build artifacts and caches

### Stage 2: Runtime
- Minimal Arch Linux base
- Runtime dependencies only
- Copies compiled tools from builder stage
- Sets up development user and environment

## Installed Tools

### System Packages (packages.list)
- Development: `github-cli`, `go`, `lazygit`
- Network: `nmap`, `tcpdump`, `termshark`, `gnu-netcat`
- Utilities: `fx`, `fzf`, `jo`, `yq`, `less`, `starship`
- File management: `nnn`, `vifm`, `stow`
- Security: `gitleaks`, `ufw`

### Rust CLI Tools
- File operations: `fd-find`, `eza`, `bat`
- System monitoring: `btm`, `bandwhich`, `gping`
- Development: `ripgrep`, `tokei`, `tree-sitter-cli`
- Web/API: `hurl`, `xh`, `websocat`
- Specialized: `jql`, `kalker`, `viu`, `twiggy`

## Workspace

The `workspace/` directory is mounted as a volume at `/workspace` inside the container, allowing you to persist work between container runs.

## User Setup

The container runs as user `developer` (UID 1000) with sudo privileges for package management and system configuration.