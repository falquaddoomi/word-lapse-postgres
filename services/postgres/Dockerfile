FROM postgres:12

RUN apt update && apt install -y python3 python3-pip git jq

WORKDIR /app
RUN git clone https://github.com/guenthermi/postgres-word2vec.git

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./import_word2vec.sh /docker-entrypoint-initdb.d
