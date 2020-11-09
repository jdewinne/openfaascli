# StackState CLI for OpenFaas

## Prerequisites

+ Have OpenFaas installed: For example you can use `arkade` to easy install it on your k8s cluster.
  ```
  arkade install openfaas \
    --set=gateway.upstreamTimeout=295s \
    --set=gateway.readTimeout=300s \
    --set=gateway.writeTimeout=300s \
    --set=faasnetes.readinessProbe.timeoutSeconds=2 \
    --set=faasnetes.livenessProbe.timeoutSeconds=2 \
    --clusterrole
  ```
+ Notice the increase in timeouts, as many CLI scripts take longer.
+ Run your functions in your own "sandbox" namespace. See [Openfaas namespaces](https://docs.openfaas.com/reference/namespaces/):
    + Run `kubectl annotate <your-namespace> openfaas="1"`.
    + Run `kubectl apply -f installation/networkpolicy-allow-ingress-from-openfaas.yaml --namespace <your-namespace>`

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
1. StackPacks:
    1. To make use of a stackpack in `stackpack-default.yml`, copy the file into `stackpack-override.yml` and override the `stackpack_download_user`. 
    1. Also create a [secret](https://docs.openfaas.com/reference/secrets/#define-a-secret-in-kubernetes-advanced) into your k8s cluster. Use the pattern `artifactory-password` for the secret name, unless you want to change that. If you change it, you'll have to set `ARTIFACTORY_PASSWORD` when deploying.
    1. If you want to make use of a different stackpack, change `stackpack_download_link`. Default is the `demo-stackpack`.
1. Deploy your function:

   `faas-cli deploy -f stscli.yml`

   or when you've defined changes in `cli-override.yml`:

   `CLI_OVERRIDE="./stscli/cli-override.yml" faas-cli deploy -f stscli.yml`

   or when you're using a different OpenFaas gateway:

   `faas-cli deploy -f stscli.yml -g "http://something:someport"`

   or when you've changed the default name for the `sts-password` secret:

   `STS_PASSWORD="sts-password-custom" faas-cli deploy -f stscli.yml`

   or when you've changed the download link:

   `DL_OVERRIDE="./stscli/msp-override.yml" faas-cli deploy -f msp.yml`

   or when you're working on a stackpack:

   `STACKPACK_OVERRIDE="./stscli/stackpack-demo-override.yml" faas-cli deploy -f demo.yml`
1. Creating a "Component Action" in StackState using OpenFaas:
    1. Use the function: `cli-graph-import`.
    1. Change the request body to `JSON`.
    1. Use the following as an example for the content:
       ```
       {"nodes":
         [{
             "_type":"ComponentActionDefinition",
             "bindQuery":"type = \"*\"",
             "description":"",
             "name":"Rollback to v5",
             "script":"Http.post('http://127.0.0.1:8080/async-function/msp-fix-problem')"
         }]
       }
       ```
1. Items that can be overriden:
    1. `CLI_OVERRIDE`: Override any value from `./stscli/cli-default.yml`.
    1. `DL_OVERRIDE`: Override any value from `./stscli/dl-default.yml`.
    1. `STACKPACK_OVERRIDE`: Override any value from `./stscli/stackpack-default.yml`.
    1. `STS_PASSWORD`: The k8s secret name that will need to be mapped onto `/var/openfaas/secrets/` (default: `sts-password`).
    1. `ARTIFACTORY_PASSWORD`: The k8s secret name that will need to be mapped onto `/var/openfaas/secrets/` (default: `artifactory-password`).
1. The `live-demo` stackpack:
    1. Deploy via `CLI_OVERRIDE="./stscli/cli-override.yml" STACKPACK_OVERRIDE="./stscli/stackpack-live-demo-override.yml" faas-cli deploy -f live-demo.yml`.
    1. The function `stackpack-install-live-demo-stackpack` requires in the request body `stackpack install live-demo -p receiverUrl <your-stackstate-instance-endpoint>`. With `your-stackstate-instance-endpoint` for example `http://abcdefghij.ngrok.io` when exposing your local instance using ngrok.
