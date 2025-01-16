FROM python:3.13-slim
LABEL maintainer="Steve Brown https://github.com/audiocomp"

# Install Additional Packages
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install rsyslog wget logrotate

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