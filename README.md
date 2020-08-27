# StackState CLI for OpenFaas

## Prerequisites

+ Have OpenFaas installed: For example you can use `arkade` to easy install it on your k8s cluster.
  ```
  arkade install openfaas --set=gateway.upstreamTimeout=295s --set=gateway.readTimeout=300s --set=gateway.writeTimeout=300s
  ```
+ Notice the increase in timeouts, as many CLI scripts take longer.  

## Usage

1. Deploy your StackState password as a [secret](https://docs.openfaas.com/reference/secrets/#define-a-secret-in-kubernetes-advanced) into your k8s cluster. Use the pattern `sts-password` for the secret name in case you're working with a single StackState instance.
1. In case you want to change the defaults from `cli-default.yml`, copy the file into `cli-override.yml` and change what is needed:
    1. `sts_username`: Define the StackState username
    1. `sts_password`: Define the k8s secret you'll use (`sts-password`)
    1. `sts_base_api`: Define the base api url (default: `http://k8s-sts:8080`)
    1. `sts_receiver_api`: Define the base api url (default: `http://k8s-sts:8080`)
    1. `sts_admin_api`: Define the base api url (default: `http://k8s-sts:8080`)
    1. `sts_api_key`: Define the API key (default: `f3ec7af4027370b18cfe96c140a8f6b1`)
1. In case you want to change the default download zip from `dl-default.yml`, copy the file into `dl-domain-override.yml` and change what is needed. This is typically only relevant when loading the `msp`, `banking`, `telco`, ... scenario.
    1. `dl_download_link`: Contains the location where to find a zipped version of the scripts to run.
    1. `dl_download_user`: The username to be used for basic auth.
    1. `dl_download_password`: The name of the k8s secret that contains the password.
1. To make use of the demo-stackpack in `stackpack-default.yml`, copy the file into `stackpack-override.yml` and override the `demo_stackpack_download_user`. Also create a [secret](https://docs.openfaas.com/reference/secrets/#define-a-secret-in-kubernetes-advanced) into your k8s cluster. Use the pattern `artifactory-password` for the secret name, unless you want to change that. If you change it, you'll have to set `ARTIFACTORY_PASSWORD` when deploying.
1. Deploy your function:

   `faas-cli deploy -f stscli.yml`

   or when you've defined changes in `cli-override.yml`:

   `CLI_OVERRIDE="./stscli/cli-override.yml" faas-cli deploy -f stscli.yml`

   or when you're using a different OpenFaas gateway:

   `OPENFAAS_GATEWAY="http://something:someport" faas-cli deploy -f stscli.yml`

   or when you've changed the default name for the `sts-password` secret:

   `STS_PASSWORD="sts-password-custom" faas-cli deploy -f stscli.yml`

   or when you've changed the download link:

   `DL_OVERRIDE="./stscli/msp-override.yml" faas-cli deploy -f msp.yml`

   or when you're working on the demo-stackpack:

   `STACKPACK_OVERRIDE="./stscli/stackpack-override.yml" faas-cli deploy -f demo.yml`
1. Items that can be overriden:
    1. `OPENFAAS_GATEWAY`: The openfaas gateway endpoint (default: `http://127.0.0.1:18080`).
    1. `CLI_OVERRIDE`: Override any value from `./stscli/cli-default.yml`.
    1. `DL_OVERRIDE`: Override any value from `./stscli/dl-default.yml`.
    1. `STACKPACK_OVERRIDE`: Override any value from `./stscli/stackpack-default.yml`.
    1. `STS_PASSWORD`: The k8s secret name that will need to be mapped onto `/var/openfaas/secrets/` (default: `sts-password`).
    1. `ARTIFACTORY_PASSWORD`: The k8s secret name that will need to be mapped onto `/var/openfaas/secrets/` (default: `artifactory-password`).
