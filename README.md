A bunch of **very opinionated** terraform modules and helper scripts to set up a free kubernetes cluster in the oracle cloud using only resources included in the [free tier](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm). The emphasis is on **very opinionated** because there isn't much room for configurability in the free tier.

## Prerequisites:
* oci cli & account
* terraform
* powershell
* kubectl (optional)
* az cli & azure account (optional)

## Modules
* __oke__: Creates a kubernetes cluster and the required networking infrastructure in the oracle cloud
* __k8s__: Installs an ingress controller and sets up a load balancer to enable inbound traffic for the cluster created in __oke__. It also contains optional scripts to help with https and dns.
* __azure-pinger__: Sets up an automation job in azure to constantly ping the kubernetes cluster, aims to generate network traffic to prevent the cluster from staying idle, because oracle reclaims idle instances.

## Getting Started
Assuming that all prerequisites are met, follow these steps:
* Remove the __.example__ from all __*.tfvars.example__ files and fill them with your values.
* Run the following scripts
```ps1
    # Deploy the oci infrastructure
    & Deploy-Module.ps1 -Module oke

    # Deploy the k8s infrastructure
    & Deploy-Module.ps1 -Module k8s
```
* If you have a domain somewhere, point it to the load balancer IP to reach the ingress controller. You can use LetsEncrypt for https and maybe [external dns](https://github.com/kubernetes-sigs/external-dns) to automate the creation of dns entries. If you don't, follow the next steps:

```ps1
    # Import the self signed trusted root certificate to enable https.
    # A tls certificate signed by this root CA was created by the k8s module and uploaded as a secret to the 
    # created kubernetes namespaces
    # You can now create ingress resources within these namespaces and reference the secret for https
    # Requires elevated permissions
    & terraform-modules/k8s/Import-RootCA.ps1

    # Create dns entries in the hosts file of your local machine
    # Requires elevated permissions
    # This will add ${SubDomain}.${top_level_domain} to the hosts file
    & terraform-modules/k8s/Add-DnsEntries.ps1 -SubDomains sample,dev1,dev2

    # Deploy a sample ingress app to verify that ingress/https is working
    # Browse to https://sample.${top_level_domain} afterwards
    # This requires a dns entry to be available
    & kubectl apply -f "./outputs/sample-ingress-app.yaml"
```
* (Optional) deploy the __azure-pinger__ module to generate traffic and prevent the instances in oci from going idle
```ps1
    # Requires an azure account and the az cli to be installed
    # the script will authenticate interactively with "az login"
    & Deploy-Module.ps1 -Module azure-pinger
```