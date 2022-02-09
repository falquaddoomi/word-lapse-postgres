#!/usr/bin/env bash

cd /app/postgres-word2vec/index_creation

# first, make postgres listen on localhost
pg_ctl -o "-c listen_addresses='localhost'" -w restart

cat << EOF > /tmp/db_config.json
{
	"username": "${POSTGRES_USER}",
	"password": "${POSTGRES_PASSWORD}",
	"host": "localhost",
	"db_name": "${POSTGRES_DB}",
	"batch_size": 50000,
	"log": ""
}
EOF

if [[ ${TEST_CONN:-0} -eq 1 ]]; then
	cat /tmp/db_config.json

	# test database connection
	python3 - <<-'____HERE'
	import os
	import psycopg2

	# init db connection
	# password='%(password)s'
	connect_str = (
		"dbname='%(db_name)s' user='%(user)s' host='%(host)s' password='%(password)s'" % {
			"db_name": os.environ.get('POSTGRES_DB'),
			"user": os.environ.get('POSTGRES_USER'),
			"host": 'localhost',
			"password": os.environ.get('POSTGRES_PASSWORD')
		}
	)
	print("Connection string: %s" % connect_str)
	con = psycopg2.connect(connect_str)
	print("Success?: %s" % con)

	cur = con.cursor()
	____HERE
fi

for yearpath in $( find /data/word2vec_models -maxdepth 1 -type d | sort ); do
    echo "Path: ${yearpath}"
    YEAR=$( basename ${yearpath} )
    echo "Year: $YEAR"

    cat <<- EOF > /tmp/vec_loader.json
	{
	    "table_name": "wordlapse_${YEAR}",
	    "index_name": "wordlapse_${YEAR}_idx",
	    "vec_file_path": "${yearpath}/${YEAR}_0.w2v.txt",
	    "normalized": false
	}
	EOF

	python3 vec2database.py /tmp/vec_loader.json /tmp/db_config.json
done
