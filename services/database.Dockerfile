FROM postgres:14
COPY seed_script.sql /docker-entrypoint-initdb.d/