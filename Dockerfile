FROM python:3.11-alpine3.18
LABEL maintainer="Steve Brown https://github.com/audiocomp"

# Update SSL
RUN apk add --no-cache --progress -v openssl

# Install Cron & LogRotate
RUN apk add --no-cache --progress -v busybox-openrc logrotate rsyslog

# Update PIP
RUN pip install --upgrade pip

# Add Volumes & Packages
VOLUME /work
VOLUME /share

RUN mkdir /app
RUN mkdir -p /var/spool/rsyslog
RUN mkdir /etc/cron.d
WORKDIR /app

# Install Required Packages
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY VERSION VERSION
COPY app/ .
COPY system/rsyslog.conf /etc/rsyslog.conf

RUN python setup.py bdist_wheel && pip install dist/*.whl
RUN rm -rf build dist *egg.info

WORKDIR /work
RUN chmod +x /app/start.sh
RUN chmod +x /app/run.py

CMD ["/app/start.sh"]
