ARG BUILD_FROM=ghcr.io/alangrainger/immich-public-proxy:1.15.1
FROM ${BUILD_FROM}

USER root

RUN apk add --no-cache jq

COPY rootfs/ /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
