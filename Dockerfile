# Secure and Minimal base-image with Python
# https://hub.docker.com/repository/docker/huggla/sam-python

# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="dev"
ARG IMAGETYPE="content"
ARG PYTHON_VERSION="2.7.17"
ARG HUBPROFILE="huggla"
ARG HUBREPO="python"
ARG HUBVERSION="$PYTHON_VERSION"
ARG PYTHONIOENCODING="UTF-8"
ARG EXCLUDEAPKS="python2"
ARG EXCLUDEDEPS="python2"
ARG RUNDEPS="libressl"
ARG BUILDDEPS="g++ ca-certificates bzip2-dev coreutils dpkg-dev dpkg expat-dev findutils gcc gdbm-dev libc-dev libnsl-dev libressl-dev libtirpc-dev linux-headers make ncurses-dev pax-utils readline-dev sqlite-dev tcl-dev tk tk-dev zlib-dev"
ARG DOWNLOADS="https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz"
ARG BUILDCMDS=\
"   cd Python-$PYTHON_VERSION "\
'&& rm -r Modules/expat Modules/_ctypes/libffi* Modules/zlib '\
'&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" '\
'&& eval "OPT=\"$CFLAGS -DTHREAD_STACK_SIZE=0x100000\" $COMMON_CONFIGURECMD --build="$gnuArch" --enable-optimizations --enable-option-checking=fatal --enable-shared --enable-unicode=ucs4 --with-system-expat --with-system-ffi --with-system-zlib --with-threads --with-ensurepip=install" '\
"&& OPT=\"\$CFLAGS -DTHREAD_STACK_SIZE=0x100000\" make -s EXTRA_CFLAGS=\"\$CFLAGS -DTHREAD_STACK_SIZE=0x100000\" PROFILE_TASK=\"-m test.regrtest --pgo test_array test_base64 test_binascii test_binhex test_binop test_bytes test_c_locale_coercion test_class test_cmath test_codecs test_compile test_complex test_csv test_decimal test_dict test_float test_fstring test_hashlib test_io test_iter test_json test_long test_math test_memoryview test_pickle test_re test_set test_slice test_struct test_time test_traceback test_unicode \" "\
'&& make install '\
"&& echo \"Python dependencies: $(find /finalfs/usr/local -type f -executable ! -name '*tkinter*' -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' | tr ',' '\n' | sort -u | awk 'system(\"[ -e /usr/local/lib/\" \$1 \" ]\") == 0 { next } { print \"so:\" \$1 }' | xargs -rt)\""
ARG FINALCMDS=\	
"   find /usr -depth -type d -a \( -name test -o -name tests -o -name idle_test \) -exec rm -rf '{}' + "\
"&& find /usr -depth -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.exe' \)"
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
