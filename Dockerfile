ARG TAG="20181204"
ARG EXCLUDEAPKS="python2"
ARG EXCLUDEDEPS="python2"

FROM huggla/alpine-official:$TAG

ENV PATH="/usr/local/bin:$PATH" \
    LANG="C.UTF-8" \
    PYTHONIOENCODING="UTF-8" \
    PYTHON_VERSION="2.7.15" \
    PYTHON_PIP_VERSION="18.1"

RUN apk add --virtual .build-deps ca-certificates bzip2-dev coreutils dpkg-dev dpkg findutils gcc gdbm-dev libc-dev libnsl-dev libressl-dev libtirpc-dev linux-headers make ncurses-dev pax-utils readline-dev sqlite-dev tcl-dev tk tk-dev zlib-dev \
 && wget -O /python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
 && mkdir -p /usr/src/python \
 && tar -xJC /usr/src/python --strip-components=1 -f /python.tar.xz \
 && rm /python.tar.xz \
 && cd /usr/src/python \
 && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && ./configure --build="$gnuArch" --enable-shared --enable-unicode=ucs4 \
 && make -j "$(nproc)" EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000" \
 && make install \
 && find /usr/local -type f -executable ! -name '*tkinter*' -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' | xargs -rt apk add --virtual .python-rundeps \
 && find /usr/local -depth \( -type d -a \( -name test -o -name tests \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) -exec rm -rf '{}' + \
 && cd / \
 && rm -rf /usr/src/python \
 && wget -O /get-pip.py "https://bootstrap.pypa.io/get-pip.py" \
 && python /get-pip.py --disable-pip-version-check --no-cache-dir "pip==$PYTHON_PIP_VERSION" \
 && find /usr/local -depth \( -type d -a \( -name test -o -name tests \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) -exec rm -rf '{}' + \
 && rm -f /get-pip.py \
 && apk del .build-deps \
 && apk info -L $(apk info | xargs) | grep -v 'contains:$' | grep -v '^$' | awk '{system("ls -la /"$1)}' | awk -F " " '{print $5" "$9}' | sort -u - > /onbuild-exclude.filelist; \
 && if [ -n "$EXCLUDEDEPS" ] || [ -n "$EXCLUDEAPKS" ]; \
    then \
       mkdir /excludefs; \
       apk --root /excludefs add --initdb; \
       ln -s /var/cache/apk/* /excludefs/var/cache/apk/; \
       if [ -n "$EXCLUDEDEPS" ]; \
       then \
          apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --root /excludefs add $EXCLUDEDEPS; \
          apk --root /excludefs info -R $EXCLUDEDEPS | grep -v 'depends on:$' | grep -v '^$' | sort -u - | xargs apk info -L | grep -v 'contains:$' | grep -v '^$' | awk '{system("ls -la /"$1)}' | awk -F " " '{print $5" "$9}' | sort -u -o /onbuild-exclude.filelist /onbuild-exclude.filelist -; \
       fi; \
       if [ -n "$EXCLUDEAPKS" ]; \
       then \
          apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --root /excludefs add $EXCLUDEAPKS; \
          apk --root /excludefs info -L $EXCLUDEAPKS | grep -v 'contains:$' | grep -v '^$' | awk '{system("ls -la /"$1)}' | awk -F " " '{print $5" "$9}' | sort -u -o /onbuild-exclude.filelist /onbuild-exclude.filelist -; \
       fi; \
       rm -rf /excludefs; \
    fi

CMD ["python2"]
