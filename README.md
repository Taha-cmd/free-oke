TODO

Prerequisites:
* windows
* oci cli & account
* terraform
* powershell
* kubectl (optional)

```ps1
    # Deploy the oci infrastructure
    & Deploy-Module.ps1 -Module oke

    # Deploy the k8s infrastructure
    & Deploy-Module.ps1 -Module k8s

    # Optional: Import the self signed trusted root certificate to enable https
    # Requires elevated permissions
    & k8s/Import-RootCA.ps1

    # Optional: Create dns entries in the hosts file
    # Requires elevated permissions
    # This will add ${SubDomain}.${top_level_domain} to the hosts file
    & k8s/Add-DnsEntries -SubDomains sample,dev1,dev2

    # Optional: deploy a sample ingress app to verify that ingress/https is working
    # Browse to https://sample.${top_level_domain} afterwards
    # This requires a dns entry to be available
    & kubectl apply -f "./outputs/sample-ingress-app.yaml"
```