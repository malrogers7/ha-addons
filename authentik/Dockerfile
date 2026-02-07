# Start with the official Authentik image
FROM ghcr.io/goauthentik/server:2024.12.0

# Switch to root to install packages
USER root

# Install PostgreSQL and Redis inside this container
RUN apt-get update && \
    apt-get install -y postgresql-15 redis-server sudo jq && \
    rm -rf /var/lib/apt/lists/*

# Copy our Orchestrator script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Home Assistant always runs as root, but we'll drop privileges for sub-services in the script
ENTRYPOINT ["/run.sh"]
