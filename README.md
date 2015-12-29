# POSHOrigin_ActiveDirectoryDNS
POSHOrigin_ActiveDirectoryDNS is a set of PowerShell 5 based DSC resources for managing Active Directory DNS objects via DSC.

## Overview
POSHOrigin_ActiveDirectoryDNS is a set of PowerShell 5 based DSC resources for managing Active Directory DNS objects via DSC. These resources are designed to be used with [POSHOrigin](https://github.com/devblackops/POSHOrigin) as a Infrastructure as Code framework, but can be used natively by standard DSC configurations as well. Integration with [POSHOrigin](https://github.com/devblackops/POSHOrigin) is accomplished via a separate 'Invoke.ps1' script included in the module.

## Resources List
* ARecord
* CNAME
* MX

### ARecord

Created, modifies, or deletes a A record object on an Active Directory DNS server.

Parameters
----------

| Name            | Type         | Required | Description
| :---------------|:-------------|:---------|:-----------|
| Name            | string       | True     | The hostname for the record
| Ensure          | string       | False    | Denotes if resource should exist or not exist
| DnsServer       | string       | True     | The Active Directory DNS server to connect to
| Credential      | pscredential | True     | Credentials with rights to manage Active Directory DNS records. In a POSHOrigin, credentials can be included under the 'secrets' hashtable or defined inline
| IPAddress       | string       | True     | IPv4 address for A record
| TTL             | int          | False    | Time to live for A record
| ZoneName        | string       | True     | DNS zone the record is associated with
| CreatePtr       | bool         | False    | Indicates that the DNS server automatically creates an associated pointer (PTR) resource record for an A record. Default: True
| AllowUpdateAny  | bool         | False    | Indicates that any authenticated user can update a resource record that has the same owner name.. Default: False
| AgeRecord       | bool         | False    | Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp. Default value: False

## POSHOrigin Example 1
```PowerShell
resource 'ActiveDirectoryDNS:ARecord' 'serverxyz' @{
    ZoneName = 'mydomain.local'
    IpAddress = '10.45.195.254'
    DnsServer = 'dc01.mydomain.local'
    CreatePtr = $true
    Secrets = @{
        Credential = @{
            resolver = 'pscredential'
            options = @{
                username = 'mydomain\administrator'
                password = 'K33p1t53cr3tK33p1t5@f3'
            }
        }
    }
}
```

## POSHOrigin Example 2
```PowerShell
resource 'ActiveDirectoryDNS:ARecord' 'serverxyz' @{
    ZoneName = 'mydomain.local'
    IpAddress = '10.45.195.254'
    DnsServer = 'dc01.mydomain.local'
    CreatePtr = $true
    Credential = Get-POSHOriginSecret 'pscredential' @{
        username = 'mydomain\administrator'
        password = 'K33p1t53cr3tK33p1t5@f3'
    }
}
```

## Traditional DSC example
```PowerShell

$cred = Get-Credential

Configuration DNSRecord {
    Import-DscResource -Name ARecord -ModuleName POSHOrigin_ActiveDirectoryDNS

    ARecord 'serverxyz' {
        Ensure = 'Present'
        Name = 'serverxyz
        IPAddress = '10.45.195.254'
        ZoneName = mydomain.local'
        DnsServer = 'dc01.mydomain.local'
        Credential = $cred
        TTL = 86400
        CreatePtr = $true
        AllowUpdateAny = $false
        AgeRecord = $false
    }
}
```
