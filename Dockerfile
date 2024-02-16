FROM python:3.11-alpine3.18
LABEL maintainer="Steve Brown https://github.com/audiocomp"

# Install Additional Packages
RUN apk add --no-cache -v ca-certificates busybox-openrc libstdc++ logrotate openssl rsyslog wget

# Install GlibC
RUN export GLIBC_VERSION=2.32-r0 \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q -O /tmp/glibc-${GLIBC_VERSION}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add --force-overwrite --no-cache -v /tmp/glibc-${GLIBC_VERSION}.apk \
    && wget -q -O /tmp/glibc-bin-${GLIBC_VERSION}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && apk add --no-cache -v /tmp/glibc-bin-${GLIBC_VERSION}.apk \
    && rm -v /tmp/*.apk

# Add Volumes
VOLUME /work
VOLUME /share

# Create Directories & add code
WORKDIR /app
RUN mkdir -p /app /var/spool/rsyslog /etc/cron.d
COPY VERSION VERSION
COPY app/ .
COPY system/rsyslog.conf /etc/rsyslog.conf
RUN chmod +x /app/start.sh
RUN chmod +x /app/run.py

# Update PIP & Install Required Python Packages
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN python setup.py bdist_wheel \
    && pip install dist/*.whl \
    && rm -rf build dist *egg.info

# Run PyCron
WORKDIR /work
CMD ["/app/start.sh"]
