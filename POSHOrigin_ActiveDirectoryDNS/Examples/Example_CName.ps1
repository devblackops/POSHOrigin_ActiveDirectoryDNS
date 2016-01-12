$DscConfigData = @{
    AllNodes = @(
        @{
            NodeName = "*"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
        @{
            NodeName = 'localhost'
        }
    )
}

Configuration Example_ARecord {
    param(
        [string[]]$NodeName = 'localhost',
        
        [Parameter(Mandatory)]
        [string]$HostName,

        [Parameter(Mandatory)]
        [string]$FQDN,

        [Parameter(Mandatory)]
        [string]$ZoneName,

        [Parameter(Mandatory)]
        [string]$DnsServer,

        [Parameter(Mandatory)]
        [pscredential]$Credential,

        [int]$TTL,

        [bool]$AllowUpdateAny,

        [bool]$AgeRecord
    )

    Import-DscResource -Name CName -ModuleName POSHOrigin_ActiveDirectoryDNS

    Node $NodeName {
        ARecord "Create$HostName" {
            Ensure = 'Present'
            Name = $HostName
            FQDN = $FQDN
            ZoneName = $ZoneName
            DnsServer = $DnsServer
            Credential = $Credential
            TTL = $TTL
            AllowUpdateAny = $AllowUpdateAny
            AgeRecord = $AgeRecord
        }
    }
}