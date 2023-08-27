[CmdletBinding()]
param (
    [Parameter(Mandatory)] [ValidateSet("oke", "k8s")] [string] $Module,
    [Parameter()] [string] [ValidateSet("TRACE", "DEBUG", "INFO", "WARN", "ERROR")] $LogLevel = "ERROR"
)

$private:sharedDir = Join-Path $PSScriptRoot "Shared"
$private:modulePath = Join-path $PSScriptRoot $Module

$env:TF_LOG = $LogLevel
terraform -chdir="$modulePath" init
terraform -chdir="$modulePath" apply -var-file="$sharedDir/oci.tfvars" -var-file="$modulePath/values.tfvars"