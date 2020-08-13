FROM openfaas/classic-watchdog:0.18.1 as watchdog

FROM stackstate/stackstate-cli:4.0.1-master-e152779

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog
RUN apt-get update && apt-get install -y \
    httpie \
    unzip \
 && rm -rf /var/lib/apt/lists/*

ADD resources/run.sh /usr/bin/run.sh
ENV fprocess="xargs python -m src.cli"
# Set to true to see request in function logs
ENV write_debug="false"

EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1
ENTRYPOINT ["/usr/bin/env"]

CMD ["fwatchdog"]
