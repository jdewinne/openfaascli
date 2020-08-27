#!/usr/bin/env bash

# Create the cli /conf.d/conf.yaml file
sts_password_parsed=$(cat /var/openfaas/secrets/$sts_password)

# Fetch the password to download the demo stackpack
if [ -n "${demo_stackpack_download_password}" ]; then
    demo_stackpack_download_password_parsed=$(cat /var/openfaas/secrets/$demo_stackpack_download_password)
fi

# Fetch the password to download the domain scripts
if [ -n "${dl_download_password}" ]; then
    dl_download_password_parsed=$(cat /var/openfaas/secrets/$dl_download_password)
fi

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

# if stackpack link is specified (demo_stackpack_download_link)
if [ -n "${demo_stackpack_download_link}" ]; then
    echo "demo_stackpack_download_link is defined: $demo_stackpack_download_link"
    http -a $demo_stackpack_download_user:$demo_stackpack_download_password_parsed -d GET $demo_stackpack_download_link -o demo-stackpack.sts
    python -m src.cli $@ demo-stackpack.sts

# if download link is specified (dl_download_link)
elif [ -n "${dl_download_link}" ]; then
    echo "dl_download_link is defined: $dl_download_link"
    http -a $dl_download_user:$dl_download_password_parsed -d GET $dl_download_link -o download.zip
    unzip -q -o download.zip
    PYTHONPATH=/ sh $@
    
else
    python -m src.cli $@
fi