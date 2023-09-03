A bunch of **very opinionated** terraform modules and helper scripts to set up a free kubernetes cluster in the oracle cloud using only resources included in the [free tier](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm). The emphasis is on **very opinionated** because there isn't much room for configurability in the free tier.

## Prerequisites:
* oci cli & account
* terraform
* powershell
* kubectl (optional)

## Repository Structure
Under terraform modules, there is a __shared-config__ folder and, currently, two terraform modules __oke__ and __k8s__. __oke__ creates the required infrastructure in the oracle cloud and __k8s__ installs an ingress controller and sets up a load balancer to enable inbound traffic. It also help contains optional scripts to help with https and dns. Use the __Deploy-Module.ps1__ script to deploy the modules (see sample below).

## Getting Started
Assuming that all prerequisites are met, follow these steps:
* Remove the __.example__ from all __*.tfvars.example__ files and fill them with your values.
* Run the following scripts
```ps1
    # Deploy the oci infrastructure
    & Deploy-Module.ps1 -Module oke

    # Deploy the k8s infrastructure
    & Deploy-Module.ps1 -Module k8s

    # Optional: Import the self signed trusted root certificate to enable https
    # Requires elevated permissions
    & terraform-modules/k8s/Import-RootCA.ps1

    # Optional: Create dns entries in the hosts file
    # Requires elevated permissions
    # This will add ${SubDomain}.${top_level_domain} to the hosts file
    & terraform-modules/k8s/Add-DnsEntries.ps1 -SubDomains sample,dev1,dev2

    # Optional: deploy a sample ingress app to verify that ingress/https is working
    # Browse to https://sample.${top_level_domain} afterwards
    # This requires a dns entry to be available
    & kubectl apply -f "./outputs/sample-ingress-app.yaml"
```