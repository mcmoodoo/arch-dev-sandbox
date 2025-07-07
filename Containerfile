FROM archlinux:latest AS builder
COPY packages.list packages.list

# Build arguments for user/group mapping
ARG USER_ID=1000
ARG GROUP_ID=1000

# Install system dependencies and Rust tooling in builder
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git curl wget sudo && \
    pacman -S --needed --noconfirm $(cat packages.list) && \
    pacman -Sc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/*

# Create non-root user in builder
RUN groupadd -g $GROUP_ID developer && \
    useradd -m -u $USER_ID -g $GROUP_ID developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER developer
WORKDIR /home/developer

# Install Rust and cargo tools
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    . $HOME/.cargo/env && \
    cargo install \
        bat \
        btm \
        eza \
        fd-find \
        gping \
        jql \
        ripgrep \
        tokei \
        tree-sitter-cli \
        wr \
        xh \
        zellij && \
    rm -rf $HOME/.cargo/registry $HOME/.cargo/git $HOME/.rustup/tmp

# Final minimal runtime image
FROM archlinux:latest
COPY packages.list packages.list

# Build arguments for user/group mapping
ARG USER_ID=1000
ARG GROUP_ID=1000

# Install only runtime dependencies needed
RUN pacman -Syu --noconfirm && \
    pacman -S --needed --noconfirm $(cat packages.list) sudo && \
    pacman -Sc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/* packages.list

# Copy user and installed tools from builder
COPY --from=builder /home/developer /home/developer

# Create user with same UID/GID to avoid permission issues
RUN groupadd -g $GROUP_ID developer && \
    useradd -m -u $USER_ID -g $GROUP_ID developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R developer:developer /home/developer

# Set up environment and starship
USER developer
WORKDIR /workspace
ENV PATH="/home/developer/.cargo/bin:$PATH"

# Initialize starship prompt and add eza alias
RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc && \
    echo 'alias ll="eza -al"' >> ~/.bashrc && \
    echo 'set -o vi' >> ~/.bashrc

CMD [ "/bin/bash" ]
