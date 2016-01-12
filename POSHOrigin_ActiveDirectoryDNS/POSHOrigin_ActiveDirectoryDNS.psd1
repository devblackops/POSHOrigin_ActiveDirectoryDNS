@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'POSHOrigin_ActiveDirectoryDNS.psm1'

    # Version number of this module.
    ModuleVersion = '1.1.2'

    # ID used to uniquely identify this module
    GUID = 'f60be00c-0f96-4ecb-9f82-b831bd21c981'

    # Author of this module
    Author = 'Brandon Olin'

    # Copyright statement for this module
    Copyright = '(c) 2015 Brandon Olin. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'POSHOrigin_ActiveDirectoryDNS is a set of PowerShell 5 based DSC resources for managing Active Directory DNS objects via DSC. These resources are designed to be used with POSHOrigin as a Infrastructure as Code framework, but can be used natively by standard DSC configurations as well. Integration with POSHOrigin is accomplished via a separate Invoke.ps1 script included in the module.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Modules that must be imported into the global environment prior to importing this module
    #RequiredModules = 'DnsServer'

    # DSC resources to export from this module
    DscResourcesToExport = @('ARecord', 'CName')
    
    PrivateData = @{
        PSData = @{
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/devblackops/POSHOrigin_ActiveDirectoryDNS'
            
            # A URL to the license for this module.
            LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'
            
             # Tags applied to this module. These help with module discovery in online galleries.            
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