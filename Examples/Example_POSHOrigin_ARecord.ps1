resource 'ActiveDirectoryDNS:ARecord' 'serverxyz' @{
    ZoneName = 'mydomain.local'
    IpAddress = '10.45.195.254'
    DnsServer = 'dc01.mydomain.local'
    CreatePtr = $true
    Credential = Get-POSHOriginSecret 'pscredential' @{
        username = 'mydomain\administrator'
        password = 'K33p1t53cr3tK33p1t5@f3'
    }
    TTL = 86400
    AllowUpdateAny = $false
    AgeRecord = $false
}