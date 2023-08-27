[CmdletBinding()]
param (
    [Parameter(Mandatory)] [string[]] $SubDomains
)

$private:loadBalanacerIp = terraform -chdir="$PSScriptRoot" output -raw "load_balancer_ip"
$private:topLevelDomain = terraform -chdir="$PSScriptRoot" output -raw "top_level_domain"

& $(Join-Path $PSScriptRoot "HelperScripts" "Add-WindowsHostsFileEntries.ps1") `
    -IpAddress $loadBalanacerIp `
    -TopLevelDomain $topLevelDomain `
    -SubDomains $SubDomains
