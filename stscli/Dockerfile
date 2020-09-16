FROM openfaas/classic-watchdog:0.18.18 as watchdog

FROM stackstate/stackstate-cli:4.1.0-master-ba4b13c

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog
RUN apt-get update && apt-get install -y \
    httpie \
    unzip \
 && rm -rf /var/lib/apt/lists/*

ADD resources/run.sh /usr/bin/run.sh
ENV fprocess="xargs /usr/bin/run.sh"
# Set to true to see request in function logs
ENV write_debug="false"

EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1
ENTRYPOINT ["/usr/bin/env"]

CMD ["fwatchdog"]
