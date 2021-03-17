FROM python:3.7-slim

ARG AIRFLOW_VERSION=1.10.15

ENV AIRFLOW_HOME=/airflow
ENV AIRFLOW_USER=airflow

RUN buildTools="gcc g++ make python3-dev"\
    && apt-get update  \
    && apt-get install -y --no-install-recommends \
        $buildTools \
        default-libmysqlclient-dev \
        libpq-dev \
        ca-certificates \
        curl \
        jq \
    && useradd -s /bin/bash -d $AIRFLOW_HOME $AIRFLOW_USER \
    && usermod -a -G tty $AIRFLOW_USER \
    && pip install \
        --use-deprecated legacy-resolver \
        --no-cache-dir \
        --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-3.7.txt" \
        --upgrade-strategy only-if-needed \
        apache-airflow[mysql,postgres,s3,crypto,slack,ssh,redis,password,kubernetes]==$AIRFLOW_VERSION \
    && apt-get purge -y --auto-remove $buildTools \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base


RUN mkdir ${AIRFLOW_HOME} && \
    chown ${AIRFLOW_USER} ${AIRFLOW_HOME}

WORKDIR ${AIRFLOW_HOME}
USER ${AIRFLOW_USER}
ENTRYPOINT ["airflow"]