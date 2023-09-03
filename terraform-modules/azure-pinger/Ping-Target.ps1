# This will run on PowerShell 5.1!

[CmdletBinding()]
param (
    [Parameter(Mandatory)] [string] $Target, # url or ip address
    [Parameter(Mandatory)] [ValidateRange(1, 1000)] [int] $Count # number of requests
)

for ($i = 0; $i -lt $Count; $i++) {
    Invoke-WebRequest $Target -UseBasicParsing
}