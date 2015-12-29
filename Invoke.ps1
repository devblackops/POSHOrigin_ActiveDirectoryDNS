<#
    This script expects to be passed a psobject with all the needed properties
    in order to invoke 'Active Directory DNS' DSC resources.
#>
[cmdletbinding()]
param(
    [parameter(mandatory)]
    [psobject]$Options,

    [bool]$Direct = $false
)

# Ensure we have a valid 'ensure' property
if ($null -eq $Options.options.Ensure) {
    $Options.Options | Add-Member -MemberType NoteProperty -Name Ensure -Value 'Present' -Force
}

# Get the resource type
$type = $Options.Resource.split(':')[1]

$hash = @{
    Name = $Options.Name
    Ensure = $Options.options.Ensure
    Credential = $Options.Options.Secrets.DnsAdmin.Credential
    DnsServer = $Options.Options.DnsServer
    ZoneName = $Options.Options.ZoneName
}

switch ($type) {
    'ARecord' {
        if ($Direct) {
            $hash.IPAddress = [IPAddress]::Parse($Options.Options.IPAddress).ToString()
            if ($null -ne $Options.Options.TTL) {
                $hash.TTL = [int]$Options.Options.TTL
            }
            if ($null -ne $Options.Options.CreatePtr) {
                $hash.CreatePtr = [bool]$Options.Options.CreatePtr
            }
            if ($null -ne $Options.Options.AllowUpdateAny) {
                $hash.AllowUpdateAny = [bool]$Options.Options.AllowUpdateAny
            }
            if ($null -ne $Options.Options.AgeRecord) {
                $hash.AgeRecord = [bool]$Options.Options.AgeRecord
            }
            return $hash
        } else {
            $confName = "$type" + '_' + $Options.Name
            Write-Verbose -Message "Returning configuration function for resource: $confName"
            Configuration $confName {
                Param (
                    [psobject]$ResourceOptions
                )

                Import-DscResource -Name ARecord -ModuleName POSHOrigin_ActiveDirectoryDNS

                ARecord $ResourceOptions.Name {
                    Ensure = $ResourceOptions.options.Ensure
                    Name = $ResourceOptions.Name
                    IPAddress = ([IPAddress]::Parse($ResourceOptions.Options.IPAddress).ToString())
                    ZoneName = $ResourceOptions.options.ZoneName
                    DnsServer = $ResourceOptions.options.DnsServer
                    Credential = $ResourceOptions.options.Secrets.DnsAdmin.Credential
                    TTL = $ResourceOptions.options.TTL
                    CreatePtr = $ResourceOptions.options.CreatePtr
                    AllowUpdateAny = $ResourceOptions.options.AllowUpdateAny
                    AgeRecord = $ResourceOptions.options.AgeRecord
                }
            }
        }
    }
}