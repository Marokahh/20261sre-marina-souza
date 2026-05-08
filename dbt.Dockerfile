FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/app

RUN pip install --no-cache-dir \
    dbt-core \
    dbt-clickhouse

# Opcional: Instalação do AWS CLI para interagir com o MinIO via shell se necessário
RUN pip install awscli

CMD ["dbt", "--version"]
