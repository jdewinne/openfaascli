#!/usr/bin/env bash

# Create the cli /conf.d/conf.yaml file
echo $sts_username
cat /var/openfaas/secrets/$sts_password

python -m src.cli $@