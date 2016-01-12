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
        [string]$IPAddress,

        [Parameter(Mandatory)]
        [string]$ZoneName,

        [Parameter(Mandatory)]
        [string]$DnsServer,

        [Parameter(Mandatory)]
        [pscredential]$Credential,

        [int]$TTL,

        [bool]$CreatePtr,

        [bool]$AllowUpdateAny,

        [bool]$AgeRecord
    )

    Import-DscResource -Name ARecord -ModuleName POSHOrigin_ActiveDirectoryDNS

    Node $NodeName {
        ARecord "Create$HostName" {
            Ensure = 'Present'
            Name = $HostName
            IPAddress = $IPAddress
            ZoneName = $ZoneName
            DnsServer = $DnsServer
            Credential = $Credential
            TTL = $TTL
            CreatePtr = $CreatePtr
            AllowUpdateAny = $AllowUpdateAny
            AgeRecord = $AgeRecord
        }
    }
}