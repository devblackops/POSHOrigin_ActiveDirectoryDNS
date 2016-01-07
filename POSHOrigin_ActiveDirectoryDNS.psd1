@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'POSHOrigin_ActiveDirectoryDNS.psm1'

    # Version number of this module.
    ModuleVersion = '1.1.1'

    # ID used to uniquely identify this module
    GUID = 'f60be00c-0f96-4ecb-9f82-b831bd21c981'

    # Author of this module
    Author = 'Brandon Olin'

    # Copyright statement for this module
    Copyright = '(c) 2015 Brandon Olin. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'DSC resources to manage Active Directory DNS records with POSHOrigin'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = 'DnsServer'

    # DSC resources to export from this module
    DscResourcesToExport = @('ARecord', 'CName')

    PrivateData = @{
        PSData = @{
            Tags = @(
                'Desired State Configuration',
                'DSC',
                'POSHOrigin',
                'DNS',
                'Infrastructure as Code',
                'IaC'
            )
        }
    }
}