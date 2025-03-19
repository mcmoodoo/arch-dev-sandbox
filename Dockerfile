FROM archlinux:latest

COPY packages.list packages.list

# Install system dependencies and Rust tooling
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git curl wget vim && \
    pacman -S --needed --noconfirm $(cat packages.list) && \
    # rustup default stable && \
    # rustup component add clippy rustfmt rust-analyzer rls rust-gdb rust-lldb && \
    pacman -Sc --noconfirm  # Clean up package cache to reduce image size

# Set default shell settings
RUN echo "set -o vi" >> /etc/bash.bashrc

# Create a non-root user for security
RUN useradd -m developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER developer
WORKDIR /workspace

# Install Cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# RUN . "$HOME/.cargo/env" 
# RUN export PATH="$HOME/.cargo/bin:$PATH"

RUN export PATH="$HOME/.cargo/bin:$PATH" && cargo install \
        bandwhich \
        bat \
        btm \
        # cargo-cache \
        # cargo-generate \
        # cargo-modules \
        evcxr \
        eza \
        fd-find \
        gping \
        hurl \
        jql \
        kalker \
        ripgrep \
        starknet-devnet \
        tokei \
        tree-sitter-cli \
        twiggy \
        viu \
        wasm-opt \
        websocat \
        wr \
        xh \
        zellij

CMD [ "/bin/bash" ]
