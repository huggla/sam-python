# Secure and Minimal base-image with Python
# https://hub.docker.com/repository/docker/huggla/sam-python

# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="2.0.2"
ARG IMAGETYPE="base"
ARG PYTHON_VERSION="2.7.17"
ARG CONTENTIMAGE1="huggla/sam-content:python-$PYTHON_VERSION"
ARG CONTENTSOURCE1="/content-app"
ARG CONTENTDESTINATION1="/finalfs/"
ARG PYTHONIOENCODING="UTF-8"
ARG RUNDEPS="libressl libffi"
ARG FINALCMDS="pip --no-cache-dir install --upgrade pip"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-base}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-build} as build
FROM ${BASEIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-base} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
