#!/usr/bin/env bash

# Create the cli /conf.d/conf.yaml file
sts_password_parsed=$(cat /var/openfaas/secrets/$sts_password)

mkdir /conf.d
cat >/conf.d/conf.yaml <<EOL
instances:
    default:
        base_api:
            url: "${sts_base_api}"
            basic_auth:
                username: "${sts_username}"
                password: "${sts_password_parsed}"
            auth:
                username: "${sts_username}"
                password: "${sts_password_parsed}"
        receiver_api:
            url: "${sts_receiver_api}"
            basic_auth:
                username: "${sts_username}"
                password: "${sts_password_parsed}"
            auth:
                username: "${sts_username}"
                password: "${sts_password_parsed}"
        admin_api:
            url: "${sts_admin_api}"
            basic_auth:
                username: "${sts_username}"
                password: "${sts_password_parsed}"
            auth:
                username: "${sts_username}"
                password: "${sts_password_parsed}"
        clients:
            default:
                api_key: "${sts_api_key}"
                hostname: "simulator"
                internal_hostname: "simulator"
cli:
    verbose: false
EOL

python -m src.cli $@