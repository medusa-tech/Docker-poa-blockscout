FROM postgres

USER postgres

COPY --chown=postgres:postgres ./ssl /var/lib/postgresql/ssl/

RUN chown postgres:postgres /var/lib/postgresql/ssl/server.crt

RUN chown postgres:postgres /var/lib/postgresql/ssl/server.key

RUN chmod 0600 /var/lib/postgresql/ssl/server.crt

RUN chmod 0600 /var/lib/postgresql/ssl/server.key
