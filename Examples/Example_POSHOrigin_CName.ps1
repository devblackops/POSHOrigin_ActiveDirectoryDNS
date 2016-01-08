resource 'POSHOrigin_ActiveDirectoryDNS:CName' 'serverxyz' @{
    ZoneName = 'mydomain.local'
    Fqdn = 'www.google.com'
    DnsServer = 'dc01.mydomain.local'
    Credential = Get-POSHOriginSecret 'pscredential' @{
        username = 'mydomain\administrator'
        password = 'K33p1t53cr3tK33p1t5@f3'
    }
    TTL = 86400
    AllowUpdateAny = $false
    AgeRecord = $false
}