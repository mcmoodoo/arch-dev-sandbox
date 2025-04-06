FROM archlinux:latest AS builder
COPY packages.list packages.list

# Install system dependencies and Rust tooling
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git curl wget sudo && \
    pacman -S --needed --noconfirm $(cat packages.list) && \
    pacman -Sc --noconfirm  # Clean up package cache to reduce image size

# Create a non-root user
RUN useradd -m developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER developer
WORKDIR /workspace

# Install Cargo and Rust tools
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    export PATH="$HOME/.cargo/bin:$PATH" && \
    cargo install \
        bandwhich \
        bat \
        btm \
        evcxr \
        eza \
        fd-find \
        gping \
        hurl \
        hyprsome \
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
        zellij && \
    rm -rf $HOME/.cargo/registry $HOME/.cargo/git

# Final minimal image
FROM archlinux:latest
COPY --from=builder /home/developer /home/developer
COPY --from=builder /usr/local/bin /usr/local/bin

# Recreate the non-root user
RUN useradd -m developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER developer
WORKDIR /workspace

CMD [ "/bin/bash" ]
