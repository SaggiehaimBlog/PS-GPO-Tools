<#
.SYNOPSIS
Get Disabled GPO in your forest.
.DESCRIPTION
The Get-GPODisabled function run on all GPO's in the forest and look for those with Disabled switch for Users or Computers
policy, or Both.
.PARAMETER GPO
You can pass only one GPO to test if needed.
.EXAMPLE
Get-GPODisabled

This command get all GPO in the forest and check to see if there is any GPO with disabled settings for User, Computer or both.
.EXAMPLE
Get-GPODisabled -GPO "WSUS-Server"

This command only check the GPO provided to see if there is any  disabled settings for User, Computer or both.
.EXAMPLE
Get-GPO -Name "WSUS-Server" | Get-GPODisabled

This command get the gpo from the pipeline, to see if there is any disabled settings for User, Computer or both.
.LINK

.NOTES
  Author: Saggie Haim
  Contact@saggiehaim.net
#>
function Get-GPODisabled {
    [cmdletbinding()]
    [outputtype([System.String])]
    [outputtype([System.Collections.ArrayList])]
    param (
        [parameter(Position = 0,
            Mandatory = $false, ValueFromPipeline)]
        [Microsoft.GroupPolicy.Gpo]$GPO = $null
    )
    try {
        Write-Verbose -Message "Importing GroupPolicy module"
        Import-Module GroupPolicy -ErrorAction Stop
    }
    catch {
        Write-Error -Message "GroupPolicy Module not found. Make sure RSAT (Remote Server Admin Tools) is installed"
        exit
    }
    if ($null -eq $GPO) {
        $DisabledGPO = New-Object System.Collections.ArrayList
        try {
            Write-Verbose -Message "Importing GroupPolicy Policies"
            $GPOs = Get-GPO -All
            Write-Verbose -Message "Found '$($GPOs.Count)' policies to check"
        }
        catch {
            Write-Error -Message "Can't Load GPO's Please make sure you have connection to the Domain Controllers"
            exit
        }
        ForEach ($gpo  in $GPOs) {
            Write-Verbose -Message "Checking '$($gpo.DisplayName)' status"
            switch ($gpo.GpoStatus) {
                ComputerSettingsDisabled {$DisabledGPO += "in '$($gpo.DisplayName)' the Computer Settings Disabled"}
                UserSettingsDisabled {$DisabledGPO += "in '$($gpo.DisplayName)' the User Settings Disabled"}
                AllSettingsDisabled {$DisabledGPO += "in '$($gpo.DisplayName)' All Settings Disabled"}
            }
        }
        if (($DisabledGPO).Count -ne 0) {
            Write-Output "The Following GPO's have settings disabled:"
            return $DisabledGPO
        }
        else {
            return "No Empty GPO's Found"
        }

    }
    else {
        Write-Verbose -Message "Checking '$($gpo.DisplayName)' link"
        switch ($gpo.GpoStatus) {
            ComputerSettingsDisabled {return "in '$($gpo.DisplayName)' the Computer Settings Disabled"}
            UserSettingsDisabled {return "in '$($gpo.DisplayName)' the User Settings Disabled"}
            AllSettingsDisabled {return "in '$($gpo.DisplayName)' All Settings Disabled"}
        }
        else {
            return Write-Output "in '$($gpo.DisplayName)' all settings enabled"
        }
    }
}