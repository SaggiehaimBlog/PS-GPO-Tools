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
function Get-GPOEmpty {
    [cmdletbinding()]
    [outputtype([System.String])]
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
        $EmptyGPO = New-Object System.Collections.ArrayList
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
            Write-Verbose -Message "Checking '$($gpo.DisplayName)' link"
            [xml]$GPOXMLReport = $gpo | Get-GPOReport -ReportType xml
            if ($null -eq $GPOXMLReport.gpo.User.ExtensionData -and $null -eq $GPOXMLReport.gpo.Computer.ExtensionData) {
                $EmptyGPO += $gpo
            }
        }
        if (($EmptyGPO).Count -ne 0) {
            Write-Output "The Following GPO's are empty:"
            return $EmptyGPO
        }
        else {
            return "No Empty GPO's Found"
        }

    }
    else {
        Write-Verbose -Message "Checking '$($gpo.DisplayName)' link"
        [xml]$GPOXMLReport = $gpo | Get-GPOReport -ReportType xml
        if ($null -eq $GPOXMLReport.gpo.User.ExtensionData -and $null -eq $GPOXMLReport.gpo.Computer.ExtensionData) {
            return Write-Warning "'$($gpo.DisplayName)' is empty"
        }
        else {
            return Write-Output "'$($gpo.DisplayName)' is no empty"
        }
    }
}