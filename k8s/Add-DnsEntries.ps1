[CmdletBinding()]
param (
    [Parameter(Mandatory)] [string[]] $SubDomains
)

$private:loadBalanacerIp = terraform output -raw "load_balancer_ip"
$private:topLevelDomain = terraform output -raw "top_level_domain"

& $(Join-Path $PSScriptRoot "HelperScripts" "Add-WindowsHostsFileEntries.ps1") `
    -IpAddress $loadBalanacerIp `
    -TopLevelDomain $topLevelDomain `
    -SubDomains $SubDomains
