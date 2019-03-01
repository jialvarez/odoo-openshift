FROM python:3.7.2-alpine

## Home and workdir
ENV APP_ROOT=/opt/app-root
ADD odoo ${APP_ROOT}
WORKDIR ${APP_ROOT}

## Install system and apps dependencies
RUN \
 apk add --no-cache postgresql-libs g++ libxslt-dev openldap-dev lsof rsync && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev vim && \
 apk --update add libxml2-dev libxslt-dev libffi-dev gcc musl-dev libgcc openssl-dev curl && \
 apk add jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev && \
 python3 -m pip install -r requirements.txt --no-cache-dir && \
 apk --purge del .build-deps

RUN mkdir -p /run/nginx

## OPTIONAL: If you want to install openhrms_core plugin (takes a HUGE amount of time installing pandas)
#RUN pip install numpy && pip install pandas
#RUN wget https://apps.odoo.com/loempia/download/ohrms_core/12.0.1.0.0/6czNBZ0bGreJgEGKl5GScy.zip?deps -P ${APP_ROOT}/addons
#RUN unzip ${APP_ROOT}/addons/6*.zip* -d ${APP_ROOT}/addons

## OPTIONAL: If you want to store database backups every day
ENV PGPASSWORD="myodoopass"

RUN apk add --no-cache postgresql-client bash

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.8/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=be43e64c45acd6ec4fce5831e03759c89676a0ea

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

## Create a non-root user
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/
COPY cron/ ${APP_ROOT}/cron/
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chmod -R u+x ${APP_ROOT}/cron && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd && \
    chmod -R g=u /run/nginx

USER 10001

ENTRYPOINT [ "uid_entrypoint" ]

## Run the app
CMD ["sh","-c", "bin/run_cmd"]
