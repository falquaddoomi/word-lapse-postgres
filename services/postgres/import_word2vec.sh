#!/usr/bin/env bash

cd /app/postgres-word2vec/index_creation

pip install psycopg2 scipy numpy

cat << EOF > ./config/db_config.json
{
	"username": "${POSTGRES_USER}",
	"password": "${POSTGRES_PASSWORD}",
	"host": "localhost",
	"db_name": "${POSTGRES_DB}",
	"batch_size": 50000,
	"log": ""
}
EOF

for yearpath in $( find /data/word2vec_models -maxdepth 1 -type d | sort ); do
    echo "Path: ${yearpath}"
    YEAR=$( basename ${yearpath} )
    echo "Year: $YEAR"

    cat <<- EOF > /tmp/vec_loader.json
	{
	    "table_name": "word-lapse_${YEAR}",
	    "index_name": "word-lapse_${YEAR}_idx",
	    "vec_file_path": "${yearpath}/${YEAR}_0.w2v.txt",
	    "normalized": false
	}
	EOF

	python3 vec2database.py
done
