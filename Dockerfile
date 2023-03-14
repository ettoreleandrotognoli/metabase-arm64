ARG metabase_repo=metabase
ARG metabase_version=latest
FROM metabase/${metabase_repo}:${metabase_version} as metabase

# From https://github.com/metabase/metabase/issues/13119#issuecomment-1000350647

FROM adoptopenjdk/openjdk11

ENV FC_LANG en-US LC_CTYPE en_US.UTF-8

# dependencies
RUN mkdir -p /plugins && chmod a+rwx /plugins && \
    useradd --shell /bin/bash metabase &&\
    usermod -aG root metabase


WORKDIR /app
USER metabase

# copy app from the offical image
COPY --from=metabase --chown=metabase /app /app

USER root
RUN chown metabase:root /app
USER metabase

# expose our default runtime port
EXPOSE 3000

# run it
ENTRYPOINT ["/app/run_metabase.sh"]
