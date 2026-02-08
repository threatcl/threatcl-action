FROM ghcr.io/threatcl/threatcl:v0.4.0
RUN apk update
RUN apk add --update bash

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
