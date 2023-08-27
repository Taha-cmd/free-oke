[CmdletBinding()]
param (
    [Parameter(Mandatory)] [string] $IpAddress,
    [Parameter(Mandatory)] [string] $TopLevelDomain,
    [Parameter(Mandatory)] [string[]] $SubDomains,
    [Parameter()] [string] $HostsFilePath = $(Join-Path "C:" "Windows" "System32" "drivers" "etc" "hosts")
)

if(-not (Test-Path $HostsFilePath)) {
    Write-Error "Hosts file '$HostsFilePath' not found"
    exit 1
}

$private:entriesToAdd = $SubDomains | ForEach-Object {"$IpAddress $_.$TopLevelDomain"}
$private:existingEntries = Get-Content $private:hostsFilePath

$entriesToAdd | ForEach-Object {
    if($existingEntries -contains $_ ) {
        Write-Warning "'$_' already exists in hosts file '$HostsFilePath'. Skipping ..."
        return
    }

    Write-Host "Adding entry '$_' to hosts file in '$HostsFilePath'"
    Add-Content -Value $_ -Path $HostsFilePath
}