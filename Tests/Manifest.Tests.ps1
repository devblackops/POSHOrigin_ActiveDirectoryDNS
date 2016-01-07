
$psVersion = $PSVersionTable.PSVersion.Major
$modulePath = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$moduleName = Split-Path -Leaf $modulePath
$manifestPath = Join-Path -Path $modulePath -Child "$moduleName.psd1"

Describe 'Manifest' {
    Context 'Manifest' {

        $manifestHash = Invoke-Expression (Get-Content $manifestPath -Raw)

        It 'has a valid manifest' {
            {
                $null = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not Throw
        }
    
        It 'has a valid root module' {
            $manifestHash.RootModule | Should Be "$moduleName.psm1"
        }
    
        It 'has a valid Description' {
            $manifestHash.Description | Should Not BeNullOrEmpty
        }

        It 'has a valid author' {
            $manifestHash.Author | Should Not BeNullOrEmpty
        }
    
        It 'has a valid guid' {
            { 
                [guid]::Parse($manifestHash.Guid) 
            } | Should Not throw
        }
    
        It 'has a valid copyright' {
            $manifestHash.CopyRight | Should Not BeNullOrEmpty
        }

        It 'exports DSC resources' {
            $manifestHash.DscResourcesToExport | Should Not BeNullOrEmpty
        }
    }
}