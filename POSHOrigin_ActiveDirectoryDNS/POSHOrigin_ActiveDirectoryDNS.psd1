@{
    #RootModule = 'POSHOrigin_ActiveDirectoryDNS.psm1'
    ModuleVersion = '1.1.3'
    GUID = 'f60be00c-0f96-4ecb-9f82-b831bd21c981'
    Author = 'Brandon Olin'
    Copyright = '(c) 2016 Brandon Olin. All rights reserved.'
    Description = 'POSHOrigin_ActiveDirectoryDNS is a set of PowerShell 5 based DSC resources for managing 
        Active Directory DNS objects via DSC. These resources are designed to be used with POSHOrigin
        as a Infrastructure as Code framework, but can be used natively by standard DSC configurations as well.
        Integration with POSHOrigin is accomplished via a separate Invoke.ps1 script included in the module.'
    PowerShellVersion = '5.0'
    NestedModules = @(
        'ARecord.psm1',
        'cname.psm1'
    )
    DscResourcesToExport = @('ARecord', 'CName')
    PrivateData = @{
        PSData = @{
            ProjectUri = 'https://github.com/devblackops/POSHOrigin_ActiveDirectoryDNS'
            LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'
            Tags = @(
                'Desired State Configuration',
                'DSC',
                'POSHOrigin',
                'DNS',
                'Infrastructure as Code',
                'IaC'
            )
            ExternalModuleDependencies = 'DnsServer'
        }
    }
}
