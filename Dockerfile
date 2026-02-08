FROM ghcr.io/threatcl/threatcl:v0.4.0
USER root
RUN apk update && apk add --no-cache bash
USER threatcl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
