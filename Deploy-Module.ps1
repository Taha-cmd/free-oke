[CmdletBinding()]
param (
    [Parameter(Mandatory)] [ValidateSet("oke", "k8s", "azure-pinger")] [string] $Module,
    [Parameter()] [string] [ValidateSet("TRACE", "DEBUG", "INFO", "WARN", "ERROR")] $LogLevel = "ERROR",
    [Parameter()] [switch] $SkipAzureInteractiveLogin
)

$private:sharedDir = Join-Path $PSScriptRoot "terraform-modules" "shared-config"
$private:modulePath = Join-path $PSScriptRoot "terraform-modules" $Module

$env:TF_LOG = $LogLevel
terraform -chdir="$modulePath" init

if ($Module -eq "azure-pinger") {

    if (-not $SkipAzureInteractiveLogin) {
        az login
    }

    terraform -chdir="$modulePath" apply -var-file="$sharedDir/shared.tfvars" -var-file="$modulePath/values.tfvars"
}
else {
    terraform -chdir="$modulePath" apply -var-file="$sharedDir/shared.tfvars" -var-file="$sharedDir/oci.tfvars" -var-file="$modulePath/values.tfvars"
}