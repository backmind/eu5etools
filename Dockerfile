# Build variables for flexibility
ARG IMG_REGISTRY=ghcr.io/5etools-mirror-3/5etools-img
ARG IMG_TAG=latest
ARG SRC_REPO=https://github.com/5etools-mirror-3/5etools-src.git
ARG SRC_BRANCH=main

FROM ${IMG_REGISTRY}:${IMG_TAG}

# Install git to clone source code
RUN apk add --no-cache git

# Build information
ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_REF

# Metadata labels
LABEL org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.version=${BUILD_VERSION} \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.title="Ever Updated 5etools" \
      org.opencontainers.image.description="5etools with auto-updated assets and source code combined"

# Clone source code in temporary directory
RUN git clone --depth=1 --branch=${SRC_BRANCH} ${SRC_REPO} /tmp/src

# Copy source code over base content
# (keeping the img/ directory that's already in base image)
RUN cp -r . /var/www/localhost/htdocs/ && \
    rm -rf /tmp/src

# Return to original working directory
WORKDIR /var/www/localhost/htdocs

# CMD is already defined in base image (lighttpd)
# But we can verify everything is in place
RUN ls -la /var/www/localhost/htdocs/ && \
    ls -la /var/www/localhost/htdocs/img/ | head -5
