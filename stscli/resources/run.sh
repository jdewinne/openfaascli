#!/usr/bin/env bash

# Create the cli /conf.d/conf.yaml file
sts_password_parsed=$(cat /var/openfaas/secrets/$sts_password)

rm -rf /conf.d
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

# if download link is specified (dl_download_link)
if [ -n "${dl_download_link}" ]; then
    echo "dl_download_link is defined: $dl_download_link"
    http -d GET $dl_download_link -o download.zip
    unzip -q -o download.zip
    PYTHONPATH=/ sh $@
else
    python -m src.cli $@
fi