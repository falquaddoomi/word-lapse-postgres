FROM postgres:12

RUN apt update && apt install -y python3 python3-pip git jq libpq-dev postgresql-server-dev-12 \
    && pip install psycopg2 scipy numpy

WORKDIR /app
RUN git clone https://github.com/guenthermi/postgres-word2vec.git && \
    cd /app/postgres-word2vec/freddy_extension && make install

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./startup_scripts/* /docker-entrypoint-initdb.d/
