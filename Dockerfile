FROM python:3.9-alpine3.13
LABEL maintainer="Steve Brown https://github.com/audiocomp"

VOLUME /work
VOLUME /share

RUN mkdir /app
WORKDIR /app

RUN apk update
RUN apk add logrotate

RUN mkdir -p /etc/cron.d/pycron

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY VERSION VERSION
COPY app/ .

RUN python setup.py bdist_wheel && pip install dist/*.whl
RUN rm -rf build dist *egg.info

WORKDIR /work
RUN chmod +x /app/start.sh
RUN chmod +x /app/run.py

CMD ["/app/start.sh"]
