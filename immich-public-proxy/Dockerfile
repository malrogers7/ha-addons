ARG BUILD_FROM=alangrainger/immich-public-proxy:latest
FROM ${BUILD_FROM}

USER root

# Install dependencies using Alpine's package manager
RUN apk add --no-cache \
    jq \
    curl

#COPY run.sh /run.sh
COPY rootfs/ /

# Ensure the script is executable
RUN chmod a+x /run.sh

# Metadata arguments
ARG BUILD_ARCH=amd64
ARG BUILD_VERSION
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="Malcolm Rogers <malcolmrgs@gmail.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Mal HA Add-ons" \
    org.opencontainers.image.authors="Malcolm Rogers <malcolmrgs@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/malrogers7" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

# Start the script
ENTRYPOINT [ "/run.sh" ]
