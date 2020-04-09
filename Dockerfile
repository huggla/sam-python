# Secure and Minimal base-image with Python
# https://hub.docker.com/repository/docker/huggla/sam-python

# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="2.0.1"
ARG IMAGETYPE="base"
ARG PYTHON_VERSION="2.7.17"
ARG PYTHON_PIP_VERSION="19.0.3"
ARG HUBPROFILE="huggla"
ARG HUBREPO="python"
ARG HUBVERSION="$PYTHON_VERSION"
ARG PYTHONIOENCODING="UTF-8"
ARG EXCLUDEAPKS="python2"
ARG EXCLUDEDEPS="python2"
ARG BUILDDEPS="ca-certificates bzip2-dev coreutils dpkg-dev dpkg findutils gcc gdbm-dev libc-dev libnsl-dev libressl-dev libtirpc-dev linux-headers make ncurses-dev pax-utils readline-dev sqlite-dev tcl-dev tk tk-dev zlib-dev"
ARG DOWNLOADS="https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz https://bootstrap.pypa.io/get-pip.py"
ARG BUILDCMDS=\
'   cd Python-$PYTHON_VERSION '\
'&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" '\
'&& eval "$COMMON_INSTALLSRC" '\
"&& find /finalfs/usr/local -type f -executable ! -name '*tkinter*' -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' | tr ',' '\n' | sort -u | awk 'system(\"[ -e /usr/local/lib/\" \$1 \" ]\") == 0 { next } { print \"so:\" \$1 }' | xargs -rt apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /finalfs add --virtual .python-rundeps "\
'&& mv ../get-pip.py /finalfs/'
ARG FINALCMDS=\
"   python /get-pip.py --disable-pip-version-check --no-cache-dir \"pip==$PYTHON_PIP_VERSION\" "\
'&& rm -f /get-pip.py '\
"&& find /usr/local -depth \( -type d -a \( -name test -o -name tests \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) -exec rm -rf '{}' +"
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
