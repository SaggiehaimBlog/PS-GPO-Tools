@{
    RootModule        = 'PS.GPO.TOOLS.psm1'
    ModuleVersion     = '0.0.1'
    # Can only use CompatiblePSEditions if PowerShellVersion is set to 5.1, not sure about limiting this to that version yet.
    # CompatiblePSEditions = @('Desktop')
    GUID              = 'fe8fc9be-9476-4c56-b680-89b1766e9c84'
    Author            = 'Saggie Haim'
    CompanyName       = 'Saggiehaim'
    Copyright         = '(c) 2020 Saggie Haim. All rights reserved.'
    Description       = 'Module for maintaning Active Directory Group Policy with PowerShell.'
    PowerShellVersion = '5.0'
    FunctionsToExport = 'Get-GPODisabled',
                        'Get-GPOEmpty',
                        'Get-GPOMissingPermissions',
                        'Get-GPOUnlinked'
    CmdletsToExport   = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('Active-Directory','Group-Policy', 'GPO-Tools', 'GPO-Maintenance', 'Saggiehaim')
            LicenseUri   = 'https://github.com/Saggiehaim/PS-GPO-Tools/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/Saggiehaim/PS-GPO-Tools'
            #IconUri      = ''
            #ReleaseNotes = 
            ExternalModuleDependencies = @('GroupPolicy')
        }
    }
}