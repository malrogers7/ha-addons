ARG BUILD_FROM=ghcr.io/alangrainger/immich-public-proxy:1.15.1
FROM ${BUILD_FROM}

# We only need to copy the script, the base image has everything else
COPY rootfs/ /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
